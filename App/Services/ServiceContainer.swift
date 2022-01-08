//
//  ServiceContainer.swift
//  Stocks
//
//  Created by likils on 29.04.2021.
//

import Foundation

protocol ServiceContainer {

    var webSocketService: WebSocketService { get }
    var cacheService: CacheService { get }
    
}

class ServiceContainerImpl: ServiceContainer {

    let webSocketService: WebSocketService
    let cacheService: CacheService
    
    init(webSocketService: WebSocketService,
         cacheService: CacheService) {

        self.webSocketService = webSocketService
        self.cacheService = cacheService
    }
    
}
