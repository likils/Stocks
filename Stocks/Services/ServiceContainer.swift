//
//  ServiceContainer.swift
//  Stocks
//
//  Created by likils on 29.04.2021.
//

import Foundation

protocol ServiceContainer {
    
    var newsService: NewsService { get }
    var currencyService: CurrencyService { get }
    var cacheService: CacheService { get }
    
}

class ServiceContainerImpl: ServiceContainer {
    
    let newsService: NewsService
    let currencyService: CurrencyService
    let cacheService: CacheService
    
    init(newsService: NewsService,
         currencyService: CurrencyService,
         cacheService: CacheService) {
        
        self.newsService = newsService
        self.currencyService = currencyService
        self.cacheService = cacheService
    }
    
}
