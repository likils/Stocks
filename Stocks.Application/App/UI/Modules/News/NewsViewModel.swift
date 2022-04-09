// ----------------------------------------------------------------------------
//
//  NewsViewModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine
import Resolver
import StocksData
import StocksNetwork
import UIKit

// ----------------------------------------------------------------------------

typealias NewsPublisher = AnyPublisher<[NewsModel], Never>
typealias ImagePublisher = AnyPublisher<UIImage?, Never>

// ----------------------------------------------------------------------------

protocol NewsViewModel: AnyObject {

    // MARK: - Methods

    func getNewsCategories() -> [NewsCategory]

    func getNewsPublisher() -> NewsPublisher

    func getImagePublisher(withSize imageSize: Double, for newsModel: NewsModel) -> ImagePublisher

    func refreshNews(with category: NewsCategory)

    func showNewsArticle(with newsModel: NewsModel)
}

// ----------------------------------------------------------------------------

final class NewsViewModelImpl {

    // MARK: - Private Properties

    private let coordinator: NewsCoordination
    private let newsCategories: [NewsCategory]

    private let newsPublisher = PassthroughSubject<[NewsModel], Never>()

    @LazyInjected private var imageRequestFactory: ImageRequestFactory
    @LazyInjected private var newsRequestFactory: NewsRequestFactory

    // MARK: - Construction

    init(coordinator: NewsCoordination, newsCategories: [NewsCategory]) {
        self.coordinator = coordinator
        self.newsCategories = newsCategories
    }

    // MARK: - Private Methods

    private func requestNews(with category: NewsCategory) async {
        do {
            let newsResponse = try await newsRequestFactory
                .createRequest(newsCategory: category)
                .execute()

            let news = newsResponse.map { NewsModel(newsResponse: $0) }

            self.newsPublisher.send(news)
        }
        catch {
            handleError(error)
        }
    }

    private func handleError(_ error: Error) {
        // TODO: Negative scenario
        print("\n\tNewsViewModel Error:", error, "\n")
    }
}

// MARK: - @protocol NewsViewModel

extension NewsViewModelImpl: NewsViewModel {

    // MARK: - Methods

    func getNewsCategories() -> [NewsCategory] {
        return self.newsCategories
    }

    func getNewsPublisher() -> NewsPublisher {
        return self.newsPublisher.eraseToAnyPublisher()
    }

    func getImagePublisher(withSize imageSize: Double, for newsModel: NewsModel) -> ImagePublisher {

        guard let imageLink = newsModel.imageLink else {
            return Just(UIImage(named: "ic_news_placeholder")!).eraseToAnyPublisher()
        }

        return Just(())
            .asyncFlatMap { [weak self] in
                return await self?.imageRequestFactory
                    .createRequest(imageLink: imageLink, imageSize: imageSize)
                    .prepareImage()
            }
            .eraseToAnyPublisher()
    }

    func refreshNews(with category: NewsCategory) {
        Task {
            await requestNews(with: category)
        }
    }

    func showNewsArticle(with newsModel: NewsModel) {
        let newsLink = newsModel.sourceLink
        self.coordinator.showWebPage(with: newsLink)
    }
}
