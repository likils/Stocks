//
//  News.swift
//  Stocks
//
//  Created by likils on 12.04.2021.
//

import Foundation

struct News: Decodable, CustomStringConvertible {
    
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
    let date: String
    
    /// News headline.
    let headline: String
    
    /// News ID. This value can be used to get the latest news only.
    let id: Int
    
    /// Thumbnail image.
    let image: URL?
    
    /// Related stocks and companies mentioned in the article.
    let related: String
    
    /// News source.
    let source: String
    
    /// News summary.
    let summary: String
    
    /// URL of the original article.
    let url: URL?
    
    // MARK: - JSON Decoding
    enum CodingKeys: String, CodingKey {
        case category
        case date = "datetime"
        case headline
        case id
        case image
        case related
        case source
        case summary
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        category = try container.decode(String.self, forKey: CodingKeys.category)
        headline = try container.decode(String.self, forKey: CodingKeys.headline)
        id = try container.decode(Int.self, forKey: CodingKeys.id)
        related = try container.decode(String.self, forKey: CodingKeys.related)
        source = try container.decode(String.self, forKey: CodingKeys.source)
        summary = try container.decode(String.self, forKey: CodingKeys.summary)
        
        let _date  = try container.decode(Double.self, forKey: CodingKeys.date)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = .current
        date = formatter.string(from: Date(timeIntervalSince1970: _date))
        
        let _image = try container.decode(String.self, forKey: CodingKeys.image)
        image = URL(string: _image)
        
        let _url = try container.decode(String.self, forKey: CodingKeys.url)
        url = URL(string: _url)
    }
    
    // MARK: - Public properties
    var description: String {
        "Category: \(category)\nTime: \(date)\nHead line: \(headline)\nSummary: \(summary)\nSource: \(source)\nImage: \(image!)"
    }
    
}
