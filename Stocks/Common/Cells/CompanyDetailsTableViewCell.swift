//
//  CompanyDetailsTableViewCell.swift
//  Stocks
//
//  Created by likils on 26.05.2021.
//

import UIKit

class CompanyDetailsTableViewCell: UITableViewCell {
    
    // MARK: - Subviews
    private let backView = CellBackgroundView()
    private let graphView = GraphView()
    
    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let companyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .Text.secondaryColor
        label.numberOfLines = 2
        return label
    }()
    
    private let stockPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .right
        label.layer.cornerRadius = 4
        return label
    }()
    
    private let priceChangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Public properties
    var companyProfile: CompanyProfile! {
        didSet {
            companyProfile.companyQuotes = nil
            symbolLabel.text = companyProfile.ticker
            companyLabel.text = companyProfile.name + "\n" + companyProfile.exchange
        }
    }
    
    var companyQuotes: CompanyQuotes? {
        didSet {
            if companyQuotes?.currentPrice != oldValue?.currentPrice {
                updateQuotes()
            }
        }
    }
    
    // MARK: - Public methods
    func setLogo(_ image: UIImage) {
        logo.image = image
    }
    
    func updateGraph(withData data: CompanyCandles) {
        
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods
    private func updateQuotes() {
        guard let quotes = companyQuotes else { return }
        
        let priceDiff = quotes.currentPrice - quotes.previousClosePrice
        let priceDiffPercent = abs((priceDiff * 100) / quotes.previousClosePrice)
        
        let diffText = priceDiff > 0 ? ("+" + priceDiff.roundForText) : priceDiff.roundForText
        
        priceChangeLabel.textColor = priceDiff < 0 ? .Text.negativePriceColor : .Text.positivePriceColor
        
        stockPriceLabel.text = quotes.currentPrice.roundForText + " " + companyProfile.currencyLogo
        priceChangeLabel.text = "\(diffText) \(companyProfile.currencyLogo) (\(priceDiffPercent.roundForText)%)"
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.addSubview(logo)
        backView.addSubview(symbolLabel)
        backView.addSubview(companyLabel)
        backView.addSubview(stockPriceLabel)
        backView.addSubview(priceChangeLabel)
        backView.addSubview(graphView)
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            logo.topAnchor.constraint(equalTo: backView.topAnchor, constant: 8),
            logo.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 8),
            logo.heightAnchor.constraint(equalToConstant: 50),
            logo.heightAnchor.constraint(equalTo: logo.widthAnchor),
            
            symbolLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 8),
            symbolLabel.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 8),
            
            companyLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 8),
            companyLabel.leadingAnchor.constraint(equalTo: symbolLabel.leadingAnchor),
            
            stockPriceLabel.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: 8),
            stockPriceLabel.leadingAnchor.constraint(equalTo: symbolLabel.leadingAnchor),
            
            priceChangeLabel.topAnchor.constraint(equalTo: stockPriceLabel.bottomAnchor, constant: 8),
            priceChangeLabel.leadingAnchor.constraint(equalTo: symbolLabel.leadingAnchor),
            
            graphView.topAnchor.constraint(equalTo: priceChangeLabel.bottomAnchor, constant: 8),
            graphView.leadingAnchor.constraint(greaterThanOrEqualTo: backView.leadingAnchor, constant: 16),
            graphView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),
            graphView.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -16),
            graphView.heightAnchor.constraint(equalToConstant: 167)
        ])
    }
}
