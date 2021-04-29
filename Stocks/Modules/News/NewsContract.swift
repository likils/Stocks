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
    
    var news: [News] { get set }
    
    func showNews(_ news: [News])
    func showImage(_ image: UIImage, at indexPath: IndexPath)
    
}
