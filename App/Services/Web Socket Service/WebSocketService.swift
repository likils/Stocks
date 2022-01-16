//
//  WebSocketServiceImpl.swift
//  Stocks
//
//  Created by likils on 19.05.2021.
//

import Foundation

protocol WebSocketService: AnyObject {
    
    var initialCompanies: [String] { get set }
    var receivedData: (([OnlineTradeModel]) -> Void)? { get set }
    
    func openConnection()
    func closeConnection()
    func subscribeTo(companyTicker: String)
    func unsubscribeFrom(companyTicker: String)
}

class WebSocketServiceImpl: NSObject, WebSocketService, URLSessionWebSocketDelegate {
    
    // MARK: - Public properties
    var initialCompanies = [String]()
    var receivedData: (([OnlineTradeModel]) -> Void)?
    
    // MARK: - Private properties
    private var webSocketTask: URLSessionWebSocketTask!
    
    // MARK: - Public Methods
    func openConnection() {
        createWebSocketTask()
        webSocketTask.resume()
    }
    
    func closeConnection() {
        let reason = "Closing connection".data(using: .utf8)
        webSocketTask.cancel(with: .goingAway, reason: reason)
    }
    
    func subscribeTo(companyTicker: String) {
        request(type: .subscribe, for: companyTicker)
    }
    
    func unsubscribeFrom(companyTicker: String) {
        request(type: .unsubscribe, for: companyTicker)
    }
    
    // MARK: - Private Methods
    private func createWebSocketTask() {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())

        let requestModel = OnlineTradesRequestModel(token: NetworkSettings.token)
        let requestEntity = try! RequestEntity(requestModel: requestModel)
        let requestProvider = WebSocketRequestProvider()
        let request = UrlRequestFactory.createUrlRequest(requestProvider, requestEntity)

        webSocketTask = session.webSocketTask(with: request)
    }
    
    private func request(type: MessageType, for companySymbol: String) {
        let requestModel = OnlineTradeMessageModel(companySymbol: companySymbol, messageType: type)
        guard let data = try? JSONEncoder().encode(requestModel) else { return }
        
        webSocketTask.send(.data(data)) { error in
            if let error = error {
                print("Error when sending a message: \(error.localizedDescription)")
            }
        }
    }
    
    private func receive() {
        webSocketTask.receive { result in
            switch result {
                case .success(let message):
                    switch message {
                        case .data(let data):
                            let trades = try? JSONDecoder().decode(OnlineTradesModel.self, from: data)
                            print("::: Data received:\n\(trades!.onlineTrades)")
                            
                        case .string(let text):
                            if let data = text.data(using: .utf8) {
                                let trades = self.fetchTradesFrom(data: data)
                                self.receivedData?(trades)
                                self.receive()
                            }
                        @unknown default:
                            print("@unknown default type in webSocketTask.receive result.")
                    }
                case .failure(let error):
                    print("Error when receiving: \(error.localizedDescription)")
            }
        }
    }
    
    private func ping() {
        webSocketTask.sendPing { error in
            if let error = error {
                print("Ping error: \(error.localizedDescription)")
            } else {
                print("{ping}")
            }
        }
    }
    
    private func fetchTradesFrom(data: Data) -> [OnlineTradeModel] {
        var onlineTradeModels = [OnlineTradeModel]()
        do {
            let tradesModel = try JSONDecoder().decode(OnlineTradesModel.self, from: data)
            onlineTradeModels = tradesModel.compress().onlineTrades
        } catch {
            if let text = String(data: data, encoding: .utf8) {
                print("Received \(text)")
                ping()
            }
        }
        
        return onlineTradeModels
    }
    
    //MARK: - URLSessionWebSocketDelegate
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Web Socket did connect")
        
        initialCompanies.forEach { companyTicker in
            subscribeTo(companyTicker: companyTicker)
        }
        initialCompanies.removeAll()
        
        ping()
        receive()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Web Socket did disconnect")
    }
    
}
