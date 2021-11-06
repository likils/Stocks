//
//  ServiceContainer.swift
//  Stocks
//
//  Created by likils on 29.04.2021.
//

import Foundation

protocol ServiceContainer {
    
    var loginService: LoginService { get }
    var newsService: NewsService { get }
    var stocksService: StocksService { get }
    var webSocketService: WebSocketService { get }
    var currencyService: CurrencyService { get }
    var cacheService: CacheService { get }
    
}

class ServiceContainerImpl: ServiceContainer {
    
    let loginService: LoginService 
    let newsService: NewsService
    let stocksService: StocksService
    let webSocketService: WebSocketService
    let currencyService: CurrencyService
    let cacheService: CacheService
    
    init(loginService: LoginService,
         newsService: NewsService,
         stocksService: StocksService,
         webSocketService: WebSocketService,
         currencyService: CurrencyService,
         cacheService: CacheService) {
        
        self.loginService = loginService
        self.newsService = newsService
        self.stocksService = stocksService
        self.webSocketService = webSocketService
        self.currencyService = currencyService
        self.cacheService = cacheService
    }
    
}
