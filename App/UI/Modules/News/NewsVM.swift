// ----------------------------------------------------------------------------
//
//  NewsVM.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine
import UIKit

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
    
// MARK: - Construction

    init(coordinator: NewsCoordination) {
        self.coordinator = coordinator
        self.newsCategories = [.general, .forex, .crypto, .merger]
    }
    
    // MARK: - Public Methods

    func updateNews(with category: NewsCategory) {
        Task {
            await requestNews(with: category)
        }
    }
    
    func requestNewsImage(withSize imageSize: CGFloat, for indexPath: IndexPath) -> ImagePublisher? {

        guard let imageLink = news[indexPath.row].imageLink else { return nil }

        return ImageRequestFactory
            .createRequest(imageLink: imageLink, imageSize: imageSize)
            .prepareImage()
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
