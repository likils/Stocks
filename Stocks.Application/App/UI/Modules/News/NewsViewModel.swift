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

typealias NewsPublisher = AnyPublisher<[NewsCellModel], Never>
typealias ImagePublisher = AnyPublisher<UIImage?, Never>

// ----------------------------------------------------------------------------

protocol NewsViewModel: AnyObject {

    // MARK: - Methods

    func getNewsCategories() -> [NewsCategory]

    func getNewsPublisher() -> NewsPublisher

    func getImagePublisher(withSize imageSize: Double, for newsModel: NewsCellModel) -> ImagePublisher

    func refreshNews(with category: NewsCategory)

    func showNewsArticle(with newsModel: NewsCellModel)
}

// ----------------------------------------------------------------------------

final class NewsViewModelImpl {

    // MARK: - Private Properties

    private unowned var coordinator: NewsCoordination
    private let newsCategories: [NewsCategory]

    private let newsPublisher = PassthroughSubject<[NewsCellModel], Never>()

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

            let news = newsResponse.map { NewsCellModel(newsResponse: $0) }

            self.newsPublisher.send(news)
        }
        catch {
            handleError(error)
        }
    }

    private func getImage(_ imageLink: URL?, _ imageSize: Double) async -> UIImage? {
        var image = UIImage(named: "ic_news_placeholder")

        if let imageLink = imageLink {
            image = await self.imageRequestFactory
                .createRequest(imageLink: imageLink, imageSize: imageSize)
                .prepareImage()
        }

        return image
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

    func getImagePublisher(withSize imageSize: Double, for newsModel: NewsCellModel) -> ImagePublisher {
        return Just((newsModel.imageLink, imageSize))
            .asyncFlatMap(getImage)
            .eraseToAnyPublisher()
    }

    func refreshNews(with category: NewsCategory) {
        Task {
            await requestNews(with: category)
        }
    }

    func showNewsArticle(with newsModel: NewsCellModel) {
        let newsLink = newsModel.sourceLink
        self.coordinator.showWebPage(with: newsLink)
    }
}
