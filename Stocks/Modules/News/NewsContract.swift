//
//  NewsContract.swift
//  Stocks
//
//  Created by likils on 26.04.2021.
//

import Foundation

protocol NewsViewModel: class {
    
    var view: NewsView? { get set }
    
    func getNews()
    
}

protocol NewsView: class {
    
    var news: [News] { get set }
    
    func showNews(_ news: [News])
    
}
