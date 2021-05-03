//
//  NewsContract.swift
//  Stocks
//
//  Created by likils on 26.04.2021.
//

import UIKit

protocol NewsViewModel: AnyObject {
    
    var view: NewsView? { get set }
    
    func getNews()
    func fetchImage(from url: URL, for indexPath: IndexPath)
    
}

protocol NewsView: AnyObject {
    
    func show(news: [News])
    func show(image: UIImage, at indexPath: IndexPath)
    
}
