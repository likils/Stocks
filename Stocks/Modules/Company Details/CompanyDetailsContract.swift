//
//  CompanyDetailsContract.swift
//  Stocks
//
//  Created by likils on 25.05.2021.
//

import UIKit

protocol CompanyDetailsViewModel: AnyObject {
    
    var view: CompanyDetailsView? { get set }
    var companyProfile: CompanyProfile { get }
    var news: [News] { get }
    
    func getCandles(withTimeline timeline: CompanyCandles.TimeLine)
    func onlineUpdateBegin()
    func onlineUpdateEnd()
    func fetchLogo()
    
    func getNews()
    func fetchImage(withSize size: Double, for indexPath: IndexPath)
    func cellTapped(at index: Int)
    
}

protocol CompanyDetailsView: AnyObject {
    
    func updateGraph(data: CompanyCandles)
    func updateQuotes()
    func showNews()
    func showImage(_ image: UIImage, at indexPath: IndexPath)
    func showLogo(_ logo: UIImage)
    
}
