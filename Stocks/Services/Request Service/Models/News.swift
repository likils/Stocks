//
//  News.swift
//  Stocks
//
//  Created by likils on 12.04.2021.
//

import Foundation

struct News: Decodable {
    
    /// Market news category for request.
    enum Category {
        case general, forex, crypto, merger
        case company(symbol: String)
        
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
                case .company(let symbol):
                    return "/company-news?symbol=\(symbol)&from=2021-03-01&to=2021-03-09"
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
    let url: URL
    
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
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        category = try container.decode(String.self, forKey: CodingKeys.category)
        date  = try container.decode(Date.self, forKey: CodingKeys.date)
        headline = try container.decode(String.self, forKey: CodingKeys.headline)
        id = try container.decode(Int.self, forKey: CodingKeys.id)
        imageUrl = try container.decode(URL.self, forKey: CodingKeys.imageUrl)
        related = try container.decode(String.self, forKey: CodingKeys.related)
        source = try container.decode(String.self, forKey: CodingKeys.source)
        summary = try container.decode(String.self, forKey: CodingKeys.summary)
        url = try container.decode(URL.self, forKey: CodingKeys.url)
    }
    
}
