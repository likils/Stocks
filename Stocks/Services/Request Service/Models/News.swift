//
//  News.swift
//  Stocks
//
//  Created by likils on 12.04.2021.
//

import Foundation

struct News: Decodable, Equatable {
    
    /// Market news category for request.
    enum Category {
        case general, forex, crypto, merger
        case company(Company)
        
        var urlPart: String {
            switch self {
                case .general:
                    return "/news?category=general"
                case .forex:
                    return "/news?category=forex"
                case .crypto:
                    return "/news?category=crypto"
                case .merger:
                    return "/news?category=merger"
                case .company(let company):
                    return "/company-news?symbol=\(company.symbol)&from=2021-03-01&to=2021-03-09"
            }
        }
    }
    
    // MARK: - Public properties
    /// News category.
    let category: String
    
    /// Published time.
    let date: Date
    
    /// News headline.
    let headline: String
    
    /// News ID. This value can be used to get the latest news.
    let id: Int
    
    /// Thumbnail image URL.
    let imageUrl: URL
    
    /// Related stocks and companies mentioned in the article.
    let related: String
    
    /// News source.
    let source: String
    
    /// News summary.
    let summary: String
    
    /// URL of the original article.
    let sourceUrl: URL
    
    // MARK: - JSON Decoding
    enum CodingKeys: String, CodingKey {
        case category
        case date = "datetime"
        case headline
        case id
        case imageUrl = "image"
        case related
        case source
        case summary
        case sourceUrl = "url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let _date  = try container.decode(Double.self, forKey: CodingKeys.date)
        date = Date(timeIntervalSince1970: _date)
        category = try container.decode(String.self, forKey: CodingKeys.category)
        headline = try container.decode(String.self, forKey: CodingKeys.headline)
        id = try container.decode(Int.self, forKey: CodingKeys.id)
        imageUrl = try container.decode(URL.self, forKey: CodingKeys.imageUrl)
        related = try container.decode(String.self, forKey: CodingKeys.related)
        source = try container.decode(String.self, forKey: CodingKeys.source)
        summary = try container.decode(String.self, forKey: CodingKeys.summary)
        sourceUrl = try container.decode(URL.self, forKey: CodingKeys.sourceUrl)
    }
    
}
