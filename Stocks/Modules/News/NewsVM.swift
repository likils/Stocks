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
    
    //MARK: - Private properties
    private let coordinator: NewsCoordination?
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
        newsService.getNews(category: .general) { [weak self] news in
            self?.news = news
        }
    }
    
    func fetchImage(from url: URL, for indexPath: IndexPath) {
        cacheService.fetchImage(from: url) { [weak self] image in
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
