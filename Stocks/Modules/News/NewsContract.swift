//
//  NewsContract.swift
//  Stocks
//
//  Created by likils on 26.04.2021.
//

import UIKit

protocol NewsViewModel: AnyObject {
    
    var view: NewsView? { get set }
    var news: [News] { get }
    var newsCategories: [News.Category] { get }
    
    func getNews(category: News.Category)
    func fetchImage(from url: URL, withSize size: Float, for indexPath: IndexPath)
    func cellTapped(with url: URL?)
    
}

protocol NewsView: AnyObject {
    
    func reloadNews(if isUpdated: Bool)
    func showImage(_ image: UIImage, at indexPath: IndexPath)
    
}
