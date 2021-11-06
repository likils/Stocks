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
    var newsCategories: [NewsType] { get }
    
    func getNews(category: NewsType)
    func fetchImage(withSize size: Double, for indexPath: IndexPath)
    func cellTapped(at index: Int)
    
}

protocol NewsView: AnyObject {
    
    func reloadNews(if isUpdated: Bool)
    func showImage(_ image: UIImage, at indexPath: IndexPath)
    
}
