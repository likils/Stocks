// ----------------------------------------------------------------------------
//
//  WebSocketValueTask.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine
import Foundation

// ----------------------------------------------------------------------------

final class WebSocketValueTask<Value: Codable>: NSObject, WebSocketTask, URLSessionWebSocketDelegate {

// MARK: - Construction

    init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest

        super.init()
    }

// MARK: - Private Properties

    private let urlRequest: URLRequest
    private let webSocketPublisher = PassthroughSubject<Value, NetworkError>()

    private var session: URLSession?
    private var webSocketTask: URLSessionWebSocketTask?

    private lazy var anyWebSocketTask = AnyWebSocketTask(webSocketTask: self)

// MARK: - Methods

    func getPublisher() -> AnyPublisher<Value, NetworkError> {
        return webSocketPublisher.eraseToAnyPublisher()
    }

    func openConnection() {

        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let webSocketTask = session.webSocketTask(with: urlRequest)

        self.session = session
        self.webSocketTask = webSocketTask

        webSocketTask.resume()
    }

    func closeConnection() {
        let reason = "Closing connection".data(using: .utf8)
        webSocketTask?.cancel(with: .goingAway, reason: reason)
        session?.finishTasksAndInvalidate()
    }

    func sendMessage(_ message: RequestEntity) {
        webSocketTask?.send(.data(message.data)) { [weak self] error in
            error.map {
                let networkError = NetworkError.webSocketSendMessageError($0)
                self?.handleError(networkError)
            }
        }
    }

    func eraseToAnyWebSocketTask() -> AnyWebSocketTask<Value> {
        return anyWebSocketTask
    }

// MARK: - URLSessionWebSocketDelegate

    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
    ) {
        sendPing()
        receive()
    }

// MARK: - Private Methods

    private func sendPing() {
        webSocketTask?.sendPing { [weak self] error in
            error.map {
                let networkError = NetworkError.webSocketPingError($0)
                self?.handleError(networkError)
            }
        }
    }

    private func receive() {
        webSocketTask?.receive { [weak self] result in
            do {
                let message = try result.get()
                self?.handleReceivedMessage(message)
            }
            catch {
                let networkError = NetworkError.webSocketResultError(error)
                self?.handleError(networkError)
            }
        }
    }

    private func handleReceivedMessage(_ message: URLSessionWebSocketTask.Message) {
        switch message {

            case .data(let data):
                handleResult(data)

            case .string(let text):
                if let data = text.data(using: .utf8) {
                    handleResult(data)
                }

            @unknown default:
                print("@unknown type of URLSessionWebSocketTask.Message: \(message)")
        }
    }

    private func handleResult(_ data: Data) {
        do {
            let result = try JSONDecoder().decode(Value.self, from: data)
            webSocketPublisher.send(result)
        }
        catch {
            if let string = String(data: data, encoding: .utf8), string.contains("ping") {
                sendPing()
            }
            else {
                let networkError = NetworkError.webSocketResultSerializationError(error)
                handleError(networkError)
            }
        }

        receive()
    }

    private func handleError(_ networkError: NetworkError) {
        webSocketPublisher.send(completion: .failure(networkError))
    }
}
