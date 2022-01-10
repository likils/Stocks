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
    private(set) var newsCategories: [NewsCategory]
    
    //MARK: - Private properties
    private let coordinator: NewsCoordination
    private let cacheService: CacheService
    
    // MARK: - Construction
    init(coordinator: NewsCoordination, cacheService: CacheService) {
        self.coordinator = coordinator
        self.cacheService = cacheService
        self.newsCategories = [.general, .forex, .crypto, .merger]
    }
    
    // MARK: - Public Methods

    func updateNews(with category: NewsCategory) {
        Task {
            await requestNews(with: category)
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

    // MARK: - Private Methods

    private func requestNews(with category: NewsCategory) async {
        do {
            news = try await NewsRequestFactory
                .createRequest(newsCategory: category)
                .execute()
        }
        catch {
            handleError(error)
        }
    }

    private func handleError(_ error: Error) {
        // TODO: Negative scenario
        print(error)
    }
}
