//
//  CompanyDetailsTableViewCell.swift
//  Stocks
//
//  Created by likils on 26.05.2021.
//

import UIKit

class CompanyDetailsTableViewCell: UITableViewCell {
    
    // MARK: - Subviews
    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.layer.backgroundColor = UIColor.View.backgroundColor.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let watchlistButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "circle"), for: .normal)
        button.setImage(UIImage(named: "star"), for: .normal)
        
        button.tag = 42
        return button
    }()
    
    private let stockPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .right
        label.layer.cornerRadius = 4
        return label
    }()
    
    private let exchangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .Text.secondaryColor
        label.numberOfLines = 2
        return label
    }()
    
    private let backView = CellBackgroundView()
    private let graphView = GraphView()
    
    private let priceChangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    private let minPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    private let maxPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    private var timelineButton: UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.Text.secondaryColor, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.setBackgroundImage(UIImage(named: "oval"), for: .selected)
        return button
    }
    
    // MARK: - Public properties
    weak var delegate: CompanyCellActionsDelegate?
    
    var companyProfile: CompanyProfile! {
        didSet {
            companyProfile.companyQuotes = nil
            exchangeLabel.text = companyProfile.exchange
        }
    }
    
    var companyQuotes: CompanyQuotes? {
        didSet {
            if companyQuotes?.currentPrice != oldValue?.currentPrice {
                updateQuotes()
            }
        }
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    func setLogo(_ image: UIImage) {
        logo.image = image
    }
    
    func updateGraph(withData data: CompanyCandles) {
        graphView.candles = data
        
        let min = NSMutableAttributedString(string: "Min ")
        let minPriceText = NSAttributedString(string: graphView.minPrice!.roundForText, attributes: [.foregroundColor: UIColor.Text.negativePriceColor])
        min.append(minPriceText)
        
        let max = NSMutableAttributedString(string: "Max ")
        let maxPriceText = NSAttributedString(string: graphView.maxPrice!.roundForText, attributes: [.foregroundColor: UIColor.Text.positivePriceColor])
        max.append(maxPriceText)
        
        minPriceLabel.attributedText = min
        maxPriceLabel.attributedText = max
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
    
    private func setupButtons() {
        watchlistButton.addTarget(delegate, action: #selector(delegate?.cellButtonTapped), for: .touchUpInside)
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(logo)
        contentView.addSubview(stockPriceLabel)
        contentView.addSubview(exchangeLabel)
        contentView.addSubview(watchlistButton)
        
        contentView.addSubview(backView)
        backView.addSubview(minPriceLabel)
        backView.addSubview(maxPriceLabel)
        backView.addSubview(priceChangeLabel)
        backView.addSubview(graphView)
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            logo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logo.heightAnchor.constraint(equalToConstant: 40),
            logo.heightAnchor.constraint(equalTo: logo.widthAnchor),
            
            stockPriceLabel.topAnchor.constraint(equalTo: logo.topAnchor),
            stockPriceLabel.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 8),
            
            exchangeLabel.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 8),
            exchangeLabel.bottomAnchor.constraint(equalTo: logo.bottomAnchor),
            
            watchlistButton.topAnchor.constraint(equalTo: logo.topAnchor),
            watchlistButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            backView.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 16),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            minPriceLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 16),
            minPriceLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 16),
            
            maxPriceLabel.topAnchor.constraint(equalTo: minPriceLabel.topAnchor),
            maxPriceLabel.leadingAnchor.constraint(equalTo: minPriceLabel.trailingAnchor, constant: 16),
            
            priceChangeLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 16),
            priceChangeLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),
            
            graphView.topAnchor.constraint(equalTo: priceChangeLabel.bottomAnchor, constant: 8),
            graphView.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: backView.trailingAnchor),
            graphView.bottomAnchor.constraint(equalTo: backView.bottomAnchor),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor , multiplier: 0.5)
        ])
    }
}
