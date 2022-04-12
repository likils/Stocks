//
//  CompanyDetailsTableViewCell.swift
//  Stocks
//
//  Created by likils on 26.05.2021.
//

import Combine
import StocksData
import StocksNetwork
import UIKit

class CompanyDetailsTableViewCell: UITableViewCell {
    
    // MARK: - Subviews
    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = CompanyDetailsTableViewCell.largeHeight / 2
        imageView.layer.backgroundColor = StocksColor.background.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let watchlistButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "ic_circle"), for: .normal)
        return button
    }()
    
    private let stockPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let exchangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = StocksColor.secondary
        return label
    }()
    
    private let priceChangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let backView = DefaultBackgroundView()
    private let graphView = GraphView()
    
    private let minPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let maxPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private var timelineButton: UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(StocksColor.secondary, for: .normal)
        button.addTarget(self, action: #selector(timelineButtonTapped), for: .touchUpInside)
        return button
    }
    
    private lazy var timelineStack: UIStackView = {
        let items = CompanyCandlesTimeline.allCases
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = Self.largeSpace
        items.forEach {
            let button = timelineButton
            button.setTitle($0.rawValue, for: .normal)
            stack.addArrangedSubview(button)
        }
        return stack
    }()
    
    // MARK: - Dimensions
    static private let smallSpace: CGFloat = 8
    static private let standartSpace: CGFloat = 16
    static private let largeSpace: CGFloat = 24
    static private let standartHeight: CGFloat = 20
    static private let largeHeight: CGFloat = 40
    
    // MARK: - Private Properties

    private var currencySymbol = ""
    private var logoImageSubscriber: AnyCancellable?
    
    // MARK: - Properties
    weak var delegate: CompanyDetailsCellDelegate?
    
    var inWatchlist = false {
        didSet {
            toggleWatchlistButton()
        }
    }
    
    var companyQuotes: CompanyQuotesModel? {
        didSet {
            if companyQuotes?.currentPrice != oldValue?.currentPrice,
               let quotes = companyQuotes {
                stockPriceLabel.text = quotes.currentPrice.textRepresentation + " " + currencySymbol
            }
        }
    }
    
    // MARK: - Construction
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        watchlistButton.addTarget(self, action: #selector(watchlistButtonTapped), for: .touchUpInside)
        setTimelineButtonSelected(by: .day)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc func watchlistButtonTapped() {
        delegate?.updateWatchlist()
        inWatchlist.toggle()
    }
    
    @objc func timelineButtonTapped(sender: UIButton) {
        if let title = sender.currentTitle,
           let timeLine = CompanyCandlesTimeline(rawValue: title) {
            delegate?.updateTimeline(timeLine)
            setTimelineButtonSelected(by: timeLine)
        }
    }
    
    // MARK: - Public Methods

    override func prepareForReuse() {
        super.prepareForReuse()

        logoImageSubscriber?.cancel()
    }

    func subscribeToImageChanges(with imagePublisher: ImagePublisher?) {
        logoImageSubscriber?.cancel()

        logoImageSubscriber = imagePublisher?
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.logo.image = $0 }
    }
    
    func updateCompanyDetails(by company: CompanyProfileModel) {
        currencySymbol = company.currency.symbol
        exchangeLabel.text = company.listedExchange
        inWatchlist = company.inWatchlist
    }
    
    func updateValues(by candles: CompanyCandlesModel, and timeline: CompanyCandlesTimeline) {
        guard let firstPrice = candles.openPrices.first else { return }
        
        graphView.candles = candles
        updatePriceDifference(with: firstPrice, in: timeline)
        updateMinAndMaxLabels(with: graphView.minPrice, and: graphView.maxPrice)
    }
    
    // MARK: - Private Methods
    private func setTimelineButtonSelected(by timeline: CompanyCandlesTimeline) {
        timelineStack.arrangedSubviews.forEach {
            guard let button = $0 as? UIButton else { return }
            if button.currentTitle == timeline.rawValue {
                button.setTitleColor(.black, for: .normal)
                button.setBackgroundImage(UIImage(named: "ic_oval"), for: .normal)
            } else {
                button.setTitleColor(StocksColor.secondary, for: .normal)
                button.setBackgroundImage(nil, for: .normal)
            }
        }
    }

    private func updatePriceDifference(with firstPrice: Double, in timeline: CompanyCandlesTimeline) {
        guard let currentPrice = companyQuotes?.currentPrice else { return }
        
        let text = NSMutableAttributedString(string: "Last \(timeline.description): ")
        
        let priceDiff = currentPrice - firstPrice
        let diffText = priceDiff > 0 ? ("+" + priceDiff.textRepresentation) : priceDiff.textRepresentation
        let diffPercentText = abs((priceDiff * 100) / firstPrice).textRepresentation + "%"
        let priceText = diffText + " " + currencySymbol + " (" + diffPercentText + ")"
        let priceColor: UIColor = priceDiff < 0 ? StocksColor.negativePrice : StocksColor.positivePrice
        let attributedPrice = NSAttributedString(string: priceText, attributes: [.foregroundColor: priceColor])
        
        text.append(attributedPrice)
        priceChangeLabel.attributedText = text
    }
    
    private func updateMinAndMaxLabels(with minPrice: Double, and maxPrice: Double) {
        let attributes: [NSAttributedString.Key : Any] = [.foregroundColor: StocksColor.secondary]
        
        let min = NSMutableAttributedString(string: "Min | ", attributes: attributes)
        let max = NSMutableAttributedString(string: "Max | ", attributes: attributes)
        
        let minPriceText = NSAttributedString(string: minPrice.textRepresentation + " " + currencySymbol,
                                              attributes: [.foregroundColor: StocksColor.negativePrice])
        let maxPriceText = NSAttributedString(string: maxPrice.textRepresentation + " " + currencySymbol,
                                              attributes: [.foregroundColor: StocksColor.positivePrice])
        min.append(minPriceText)
        max.append(maxPriceText)
        
        minPriceLabel.attributedText = min
        maxPriceLabel.attributedText = max
    }
    
    private func toggleWatchlistButton() {
        let pictureName = inWatchlist ? "btn_star_filled" : "btn_star"
        watchlistButton.setImage(UIImage(named: pictureName), for: .normal)
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(logo)
        contentView.addSubview(watchlistButton)
        contentView.addSubview(stockPriceLabel)
        contentView.addSubview(exchangeLabel)
        contentView.addSubview(priceChangeLabel)
        contentView.addSubview(timelineStack)
        
        contentView.addSubview(backView)
        backView.addSubview(minPriceLabel)
        backView.addSubview(maxPriceLabel)
        backView.addSubview(graphView)
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Self.standartSpace),
            logo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Self.standartSpace),
            logo.heightAnchor.constraint(equalToConstant: Self.largeHeight),
            logo.heightAnchor.constraint(equalTo: logo.widthAnchor),
            
            watchlistButton.topAnchor.constraint(equalTo: logo.topAnchor),
            watchlistButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Self.standartSpace),
            
            stockPriceLabel.topAnchor.constraint(equalTo: logo.topAnchor),
            stockPriceLabel.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: Self.smallSpace),
            
            exchangeLabel.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: Self.smallSpace),
            exchangeLabel.bottomAnchor.constraint(equalTo: logo.bottomAnchor),
            
            priceChangeLabel.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: Self.standartSpace),
            priceChangeLabel.leadingAnchor.constraint(equalTo: logo.leadingAnchor),
            priceChangeLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Self.standartHeight),
            
            backView.topAnchor.constraint(equalTo: priceChangeLabel.bottomAnchor, constant: Self.smallSpace),
            backView.leadingAnchor.constraint(equalTo: logo.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: watchlistButton.trailingAnchor),
            
            minPriceLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: Self.standartSpace),
            minPriceLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: Self.standartSpace),
            minPriceLabel.heightAnchor.constraint(equalTo: priceChangeLabel.heightAnchor),
            
            maxPriceLabel.topAnchor.constraint(equalTo: minPriceLabel.topAnchor),
            maxPriceLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -Self.standartSpace),
            maxPriceLabel.heightAnchor.constraint(equalTo: minPriceLabel.heightAnchor),
            
            graphView.topAnchor.constraint(equalTo: minPriceLabel.bottomAnchor, constant: Self.smallSpace),
            graphView.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: backView.trailingAnchor),
            graphView.bottomAnchor.constraint(equalTo: backView.bottomAnchor),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor , multiplier: 0.5),
            
            timelineStack.topAnchor.constraint(equalTo: backView.bottomAnchor, constant: Self.smallSpace),
            timelineStack.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: Self.smallSpace),
            timelineStack.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -Self.smallSpace),
            timelineStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            timelineStack.heightAnchor.constraint(equalToConstant: Self.standartHeight)
        ])
    }
}