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
    private(set) var news = [News]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.view?.reloadNews(if: self?.news != oldValue)
            }
        }
    }
    private(set) var newsCategories: [News.Category]
    
    //MARK: - Private properties
    private let coordinator: NewsCoordination
    private let newsService: NewsService
    private let cacheService: CacheService
    
    // MARK: - Init
    init(coordinator: NewsCoordination, newsService: NewsService, cacheService: CacheService) {
        self.coordinator = coordinator
        self.newsService = newsService
        self.cacheService = cacheService
        self.newsCategories = [News.Category.general,
                               News.Category.forex,
                               News.Category.crypto,
                               News.Category.merger]
    }
    
    // MARK: - Public properties
    func getNews(category: News.Category) {
        newsService.getNews(category: category) { [weak self] news in
            self?.news = news
        }
    }
    
    func fetchImage(withSize size: Double, for indexPath: IndexPath) {
        guard let url = news[indexPath.row].imageUrl else { return }
        
        cacheService.fetchImage(from: url, withSize: size) { [weak self] image in
            DispatchQueue.main.async {
                self?.view?.showImage(image, at: indexPath)
            }
        }
    }
    
    func cellTapped(at index: Int) {
        let url = news[index].sourceUrl
        coordinator.showWebPage(with: url)
    }
    
}
