// ----------------------------------------------------------------------------
//
//  NewsViewModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine
import Foundation

// ----------------------------------------------------------------------------

typealias NewsPublisher = AnyPublisher<[NewsModel], Never>

// ----------------------------------------------------------------------------

final class NewsViewModel {
    
// MARK: - Construction

    init(coordinator: NewsCoordination, newsCategories: [NewsCategory]) {
        self.coordinator = coordinator
        self.newsCategories = newsCategories
    }

//MARK: - Private Properties

    private let coordinator: NewsCoordination
    private let newsCategories: [NewsCategory]

    private let newsPublisher = PassthroughSubject<[NewsModel], Never>()

// MARK: - Private Methods

    private func requestNews(with category: NewsCategory) async {
        do {
            let news = try await NewsRequestFactory
                .createRequest(newsCategory: category)
                .execute()

            self.newsPublisher.send(news)
        }
        catch {
            handleError(error)
        }
    }

    private func handleError(_ error: Error) {
        // TODO: Negative scenario
        print("Handled News error: ", error)
    }
}

// ----------------------------------------------------------------------------
// MARK: - @protocol NewsViewOutput

extension NewsViewModel: NewsViewOutput {

// MARK: - Methods

    func getNewsCategories() -> [NewsCategory] {
        return self.newsCategories
    }

    func getNewsPublisher() -> NewsPublisher {
        return self.newsPublisher.eraseToAnyPublisher()
    }

    func refreshNews(with category: NewsCategory) {
        Task {
            await requestNews(with: category)
        }
    }

    func requestNewsImage(withSize imageSize: Double, for newsModel: NewsModel) -> ImagePublisher? {

        guard let imageLink = newsModel.imageLink else { return nil }

        return ImageRequestFactory
            .createRequest(imageLink: imageLink, imageSize: imageSize)
            .prepareImage()
    }

    func showNewsArticle(with newsModel: NewsModel) {
        let newsLink = newsModel.sourceLink
        coordinator.showWebPage(with: newsLink)
    }
}
