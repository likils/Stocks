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
    var initTimeline: CompanyCandles.TimeLine { get }
    var news: [News] { get }
    
    func getCandles(withTimeline timeline: CompanyCandles.TimeLine)
    func fetchLogo()
    func onlineUpdateBegin()
    func onlineUpdateEnd()
    func updateWatchlist()
    func close()
    
    func getNews()
    func fetchImage(withSize size: Double, for indexPath: IndexPath)
    func cellTapped(at index: Int)
    
}

protocol CompanyDetailsView: AnyObject {
    
    func updateValues(by candles: CompanyCandles, and timeline: CompanyCandles.TimeLine)
    func updateQuotes()
    func showNews()
    func showImage(_ image: UIImage, at indexPath: IndexPath)
    func showLogo(_ logo: UIImage)
    
}

protocol CompanyDetailsCellDelegate: AnyObject {
    
    func updateWatchlist()
    func updateTimeline(_ timeline: CompanyCandles.TimeLine)
    
}
