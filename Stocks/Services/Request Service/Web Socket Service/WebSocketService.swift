//
//  WebSocketServiceImpl.swift
//  Stocks
//
//  Created by likils on 19.05.2021.
//

import Foundation

protocol WebSocketService: AnyObject {
    
    var initialCompanies: [CompanyProfile] { get set }
    var receivedData: (([OnlineTrade]) -> Void)? { get set }
    
    func openConnection()
    func closeConnection()
    func subscribeTo(company: CompanyProfile)
    func unsubscribeFrom(company: CompanyProfile)
}

class WebSocketServiceImpl: NSObject, WebSocketService, URLSessionWebSocketDelegate {
    private enum MessageType: String {
        case subscribe, unsubscribe
    }
    
    // MARK: - Public properties
    var initialCompanies = [CompanyProfile]()
    var receivedData: (([OnlineTrade]) -> Void)?
    
    // MARK: - Private properties
    private var webSocketTask: URLSessionWebSocketTask!
    
    // MARK: - Public methods
    func openConnection() {
        createWebSocketTask()
        webSocketTask.resume()
    }
    
    func closeConnection() {
        let reason = "Closing connection".data(using: .utf8)
        webSocketTask.cancel(with: .goingAway, reason: reason)
    }
    
    func subscribeTo(company: CompanyProfile) {
        request(type: .subscribe, for: company)
    }
    
    func unsubscribeFrom(company: CompanyProfile) {
        request(type: .unsubscribe, for: company)
    }
    
    // MARK: - Private methods
    private func createWebSocketTask() {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let url = URL(string: "wss://ws.finnhub.io?token=c1o6ggq37fkqrr9safcg")!
        webSocketTask = session.webSocketTask(with: url)
    }
    
    private func request(type: MessageType, for company: CompanyProfile) {
        let message = ["type": type.rawValue, "symbol": company.ticker]
        guard let data = try? JSONEncoder().encode(message) else { return }
        
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
                            let trades = try? JSONDecoder().decode(OnlineTrades.self, from: data)
                            print("::: Data received:\n\(trades!.data)")
                            
                        case .string(let text):
                            if let data = text.data(using: .utf8) {
                                let trades = self.fetchTradesFrom(data: data)
                                self.receivedData?(trades)
                            }
                        @unknown default:
                            print("@unknown default type in webSocketTask.receive result.")
                    }
                case .failure(let error):
                    print("Error when receiving: \(error.localizedDescription)")
            }
            
            self.receive()
            
        }
    }
    
    private func ping() {
        webSocketTask.sendPing { error in
            if let error = error {
                print("Ping error: \(error.localizedDescription)")
            } else {
                print("{ping}")
                
                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 15) {
                    self.ping()
                }
            }
        }
    }
    
    private func fetchTradesFrom(data: Data) -> [OnlineTrade] {
        var onlineTrades = [OnlineTrade]()
        
        if let trades = try? JSONDecoder().decode(OnlineTrades.self, from: data) {
            
            trades.data.forEach { trade in
                if !onlineTrades.contains(trade) {
                    onlineTrades.append(trade)
                }
            }
        }
        
        return onlineTrades
    }
    
    //MARK: - URLSessionWebSocketDelegate
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Web Socket did connect")
        
        initialCompanies.forEach { company in
            request(type: .subscribe, for: company)
        }
        initialCompanies.removeAll()
        
        ping()
        receive()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Web Socket did disconnect")
    }
    
}
