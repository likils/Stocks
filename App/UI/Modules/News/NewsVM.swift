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
    private(set) var news = [NewsModel]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.view?.reloadNews(if: self?.news != oldValue)
            }
        }
    }
    private(set) var newsCategories: [NewsType]
    
    //MARK: - Private properties
    private let coordinator: NewsCoordination
    private let newsService: NewsService
    private let cacheService: CacheService
    
    // MARK: - Construction
    init(coordinator: NewsCoordination, newsService: NewsService, cacheService: CacheService) {
        self.coordinator = coordinator
        self.newsService = newsService
        self.cacheService = cacheService
        self.newsCategories = [NewsType.general,
                               NewsType.forex,
                               NewsType.crypto,
                               NewsType.merger]
    }
    
    // MARK: - Public properties
    func getNews(category: NewsType) {
        newsService.getNews(category: category) { [weak self] news in
            self?.news = news
        }
    }
    
    func fetchImage(withSize size: Double, for indexPath: IndexPath) {
        guard let url = news[indexPath.row].imageLink else { return }
        
        cacheService.fetchImage(from: url, withSize: size) { [weak self] image in
            DispatchQueue.main.async {
                self?.view?.showImage(image, at: indexPath)
            }
        }
    }
    
    func cellTapped(at index: Int) {
        let url = news[index].sourceLink
        coordinator.showWebPage(with: url)
    }
    
}
