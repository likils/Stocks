//
//  StocksTableViewCell.swift
//  Stocks
//
//  Created by likils on 01.05.2021.
//

import UIKit

class StocksTableViewCell: UITableViewCell {
    
    // MARK: - Subviews
    private let backView = CellBackgroundView()
    
    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
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
        label.setContentCompressionResistancePriority(UILayoutPriority(749), for: .horizontal)
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
    var companyProfile: CompanyProfileViewModel? {
        didSet {
            symbolLabel.text = companyProfile?.tickerSymbol
            companyLabel.text = companyProfile?.name
        }
    }
    
    var companyQuotes: CompanyQuotesModel? {
        didSet {
            if companyQuotes?.currentPrice != oldValue?.currentPrice,
               let quotes = companyQuotes,
               let profile = companyProfile {
                
                let priceDiff = quotes.currentPrice - quotes.previousClosePrice
                let priceDiffPercent = abs((priceDiff * 100) / quotes.previousClosePrice)
                
                let diffText = priceDiff > 0 ? ("+" + priceDiff.roundForText) : priceDiff.roundForText
                
                priceChangeLabel.textColor = priceDiff < 0 ? .Text.negativePriceColor : .Text.positivePriceColor
                
                let pricebackgroundColor: UIColor = quotes.currentPrice < (oldValue?.currentPrice ?? 0) ? .Text.negativePriceColor : .Text.positivePriceColor
                stockPriceLabel.animateBackgroundColor(with: pricebackgroundColor)
                
                stockPriceLabel.text = quotes.currentPrice.roundForText + " " + profile.currency.symbol
                priceChangeLabel.text = "\(diffText) \(profile.currency.symbol) (\(priceDiffPercent.roundForText)%)"
            }
        }
    }
    
    // MARK: - Construction
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setLogo(_ image: UIImage) {
        logo.image = image
    }
    
    func animate(completion: (() -> Void)? = nil) {
        backView.animate(completion: completion)
    }
    
    // MARK: - Private Methods
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
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            backView.heightAnchor.constraint(equalToConstant: 64),
            
            logo.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            logo.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 16),
            logo.heightAnchor.constraint(equalToConstant: 40),
            logo.heightAnchor.constraint(equalTo: logo.widthAnchor),
            
            symbolLabel.topAnchor.constraint(equalTo: logo.topAnchor),
            symbolLabel.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 8),
            
            companyLabel.leadingAnchor.constraint(equalTo: symbolLabel.leadingAnchor),
            companyLabel.bottomAnchor.constraint(equalTo: logo.bottomAnchor),
            
            stockPriceLabel.topAnchor.constraint(equalTo: symbolLabel.topAnchor),
            stockPriceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: symbolLabel.trailingAnchor, constant: 16),
            stockPriceLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),
            
            priceChangeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: companyLabel.trailingAnchor, constant: 16),
            priceChangeLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),
            priceChangeLabel.bottomAnchor.constraint(equalTo: companyLabel.bottomAnchor)
        ])
    }

}
