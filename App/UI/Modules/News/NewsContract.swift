//
//  NewsContract.swift
//  Stocks
//
//  Created by likils on 26.04.2021.
//

import UIKit

protocol NewsViewModel: AnyObject {
    
    var view: NewsView? { get set }
    var news: [NewsModel] { get }
    var newsCategories: [NewsCategory] { get }
    
    func updateNews(with category: NewsCategory)
    func requestNewsImage(withSize imageSize: CGFloat, for indexPath: IndexPath) -> ImagePublisher?
    func cellTapped(at index: Int)
    
}

protocol NewsView: AnyObject {
    
    func reloadNews(if isUpdated: Bool)
    
}
