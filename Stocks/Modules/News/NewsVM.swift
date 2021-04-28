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
    
    // MARK: - Init
    init(coordinator: NewsCoordination, newsService: NewsService) {
        self.coordinator = coordinator
        self.newsService = newsService
    }
    
    // MARK: - Public properties
    func getNews() {
        newsService.getNews(category: .general) { news in
            DispatchQueue.main.async {
                self.view?.showNews(news)
            }
        }
    }
    
}
