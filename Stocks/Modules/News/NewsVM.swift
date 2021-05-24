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
    private let coordinator: NewsCoordination?
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
    
    func fetchImage(from url: URL, withSize size: Float, for indexPath: IndexPath) {
        cacheService.fetchImage(from: url, withSize: size) { [weak self] image in
            DispatchQueue.main.async {
                self?.view?.showImage(image, at: indexPath)
            }
        }
    }
    
    func cellTapped(with url: URL?) {
        guard let url = url else { return }
        coordinator?.showWebPage(with: url)
    }
    
}
