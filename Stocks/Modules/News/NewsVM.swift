//
//  NewsVM.swift
//  Stocks
//
//  Created by likils on 26.04.2021.
//

import Foundation

class NewsVM: NewsViewModel {
    
    // MARK: - Public properties
    weak var view: NewsView?
    
    //MARK: - Private properties
    private let coordinator: NewsCoordination
    private let newsService: NewsService
    private let cacheService: CacheService
    
    // MARK: - Init
    init(coordinator: NewsCoordination, newsService: NewsService, cacheService: CacheService) {
        self.coordinator = coordinator
        self.newsService = newsService
        self.cacheService = cacheService
    }
    
    // MARK: - Public properties
    func getNews() {
        newsService.getNews(category: .general) { news in
            DispatchQueue.main.async {
                self.view?.show(news: news)
            }
        }
    }
    
    func fetchImage(from url: URL, for indexPath: IndexPath) {
        cacheService.fetchImage(from: url) { image in
            DispatchQueue.main.async {
                self.view?.show(image: image, at: indexPath)
            }
        }
    }
    
}
