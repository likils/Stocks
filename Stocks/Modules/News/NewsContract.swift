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
    func fetchImage(withSize size: Double, for indexPath: IndexPath)
    func cellTapped(at index: Int)
    
}

protocol NewsView: AnyObject {
    
    func reloadNews(if isUpdated: Bool)
    func showImage(_ image: UIImage, at indexPath: IndexPath)
    
}
