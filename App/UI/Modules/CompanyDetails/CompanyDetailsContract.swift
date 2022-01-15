//
//  CompanyDetailsContract.swift
//  Stocks
//
//  Created by likils on 25.05.2021.
//

import UIKit

protocol CompanyDetailsViewModel: AnyObject {
    
    var view: CompanyDetailsView? { get set }
    var companyProfile: CompanyProfileViewModel { get }
    var initTimeline: CompanyCandlesTimeline { get }
    var news: [NewsModel] { get }
    
    func getCandles(withTimeline timeline: CompanyCandlesTimeline)
    func requestLogoImage() -> ImagePublisher?
    func onlineUpdateBegin()
    func onlineUpdateEnd()
    func updateWatchlist()
    func close()
    
    func getNews()
    func requestNewsImage(withSize imageSize: CGFloat, for indexPath: IndexPath) -> ImagePublisher?
    func cellTapped(at index: Int)
    
}

protocol CompanyDetailsView: AnyObject {
    
    func updateValues(by candles: CompanyCandlesModel, and timeline: CompanyCandlesTimeline)
    func updateQuotes()
    func showNews()
    
}

protocol CompanyDetailsCellDelegate: AnyObject {
    
    func updateWatchlist()
    func updateTimeline(_ timeline: CompanyCandlesTimeline)
    
}
