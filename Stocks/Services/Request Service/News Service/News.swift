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
        case company(CompanyProfile)
        
        var urlPath: String {
            switch self {
                case .company:
                    return "/company-news?"
                default:
                    return "/news?"
            }
        }
        
        var query: [String: String] {
            switch self {
                case .general:
                    return ["category": "general"]
                case .forex:
                    return ["category": "forex"]
                case .crypto:
                    return ["category": "crypto"]
                case .merger:
                    return ["category": "merger"]
                case .company(let company):
                    let pastDate = Calendar.current.date(byAdding: .day, value: -10, to: Date())!
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    
                    let past = formatter.string(from: pastDate)
                    let present = formatter.string(from: Date())
                    
                    return ["symbol": company.ticker,
                            "from": past,
                            "to": present]
            }
        }
        
        var name: String {
            switch self {
                case .general:
                    return "👋🏻General"
                case .forex:
                    return "📈Forex"
                case .crypto:
                    return "💰Crypto"
                case .merger:
                    return "👔Merger"
                case .company(let company):
                    return company.ticker
            }
        }
        
        var width: Int {
            switch self {
                case .general:
                    return 94
                case .forex:
                    return 80
                case .crypto:
                    return 86
                case .merger:
                    return 90
                case .company(_):
                    return 80
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
    let imageUrl: URL?
    
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
        let _imageUrl = try container.decode(String.self, forKey: CodingKeys.imageUrl)
        imageUrl = URL(string: _imageUrl)
        related = try container.decode(String.self, forKey: CodingKeys.related)
        source = try container.decode(String.self, forKey: CodingKeys.source)
        summary = try container.decode(String.self, forKey: CodingKeys.summary)
        sourceUrl = try container.decode(URL.self, forKey: CodingKeys.sourceUrl)
    }
    
}
