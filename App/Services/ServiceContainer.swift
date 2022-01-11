//
//  ServiceContainer.swift
//  Stocks
//
//  Created by likils on 29.04.2021.
//

import Foundation

protocol ServiceContainer {

    var webSocketService: WebSocketService { get }

}

class ServiceContainerImpl: ServiceContainer {

    let webSocketService: WebSocketService

    init(webSocketService: WebSocketService) {
        self.webSocketService = webSocketService
    }
}
