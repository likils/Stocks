// ----------------------------------------------------------------------------
//
//  StocksCell.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine
import StocksData
import StocksSystem
import UIKit

// ----------------------------------------------------------------------------

final class StocksCell: UITableViewCell {

    // MARK: - Subviews

    private let logoImageView = UIImageView() <- {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = Const.logoCornerRadius
    }

    private let tickerLabel = UILabel() <- {
        $0.font = StocksFont.title3
        $0.setContentCompressionResistancePriority(UILayoutPriority(749), for: .horizontal)
    }

    private let companyNameLabel = UILabel() <- {
        $0.font = StocksFont.body
        $0.textColor = StocksColor.secondary
        $0.setContentCompressionResistancePriority(UILayoutPriority(749), for: .horizontal)
    }

    private let stockPriceLabel = UILabel() <- {
        $0.font = StocksFont.body
        $0.textAlignment = .right
        $0.layer.cornerRadius = 4
    }

    private let priceDiffLabel = UILabel() <- {
        $0.font = StocksFont.body
        $0.textAlignment = .right
    }

    private let separatorView = UIView() <- {
        $0.backgroundColor = StocksColor.separator
    }

    // MARK: - Private Properties

    private var currencySymbol: String = .empty
    private var currentPrice: Double = .nan
    private var previousClosePrice: Double = .nan
    private var subscriptions: Set<AnyCancellable> = .empty

    // MARK: - Construction

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    override func prepareForReuse() {
        self.subscriptions.removeAll()

        super.prepareForReuse()
    }

    func updateView(with companyProfile: CompanyProfileModel) {

        self.tickerLabel.text = companyProfile.ticker
        self.companyNameLabel.text = companyProfile.name

        self.currencySymbol = companyProfile.currency.symbol

        let companyQuotes = companyProfile.companyQuotes
        self.previousClosePrice = companyQuotes.previousClosePrice

        let currentPrice = companyQuotes.currentPrice
        updatePrice(currentPrice)
    }

    func subscribeToImageChanges(with imagePublisher: ImagePublisher) {
        imagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.logoImageView.image = $0 }
            .store(in: &self.subscriptions)
    }

    func subscribeToOnlineTrade(with onlineTradePublisher: OnlineTradePublisher) {
        onlineTradePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.updatePrice($0.price) }
            .store(in: &self.subscriptions)
    }

    func updateSeparator(isHidden: Bool) {
        self.separatorView.isHidden = isHidden
    }

    // MARK: - Private Methods

    private func updatePrice(_ newPrice: Double) {

        guard self.currentPrice.textRepresentation != newPrice.textRepresentation else { return }

        self.stockPriceLabel.text = newPrice.textRepresentation + " " + self.currencySymbol

        let priceColor = (self.currentPrice > newPrice) ? StocksColor.negativePrice : StocksColor.positivePrice
        self.stockPriceLabel.animateBackgroundColor(with: priceColor)

        self.currentPrice = newPrice

        updatePriceDiff()
    }

    private func updatePriceDiff() {

        let priceDiff = self.currentPrice - self.previousClosePrice
        let priceDiffPercent = abs((priceDiff * 100) / self.previousClosePrice)

        let diffText = (priceDiff > 0)
            ? ("+" + priceDiff.textRepresentation)
            : priceDiff.textRepresentation

        self.priceDiffLabel.text = "\(diffText) \(self.currencySymbol) (\(priceDiffPercent.textRepresentation)%)"
        self.priceDiffLabel.textColor = (priceDiff < 0) ? StocksColor.negativePrice : StocksColor.positivePrice
    }

    private func setupView() {
        contentView.addSubview(logoImageView)
        contentView.addSubview(tickerLabel)
        contentView.addSubview(companyNameLabel)
        contentView.addSubview(stockPriceLabel)
        contentView.addSubview(priceDiffLabel)
        contentView.addSubview(separatorView)

        setupConstraints()
    }

    private func setupConstraints() {

        logoImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(16)
            make.height.equalTo(logoImageView.snp.width)
            make.height.equalTo(Const.logoHeight)
        }

        tickerLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView)
            make.leading.equalTo(logoImageView.snp.trailing).offset(8)
        }

        companyNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(tickerLabel)
            make.bottom.equalTo(logoImageView)
        }

        stockPriceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(tickerLabel)
            make.leading.greaterThanOrEqualTo(tickerLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
        }

        priceDiffLabel.snp.makeConstraints { make in
            make.centerY.equalTo(companyNameLabel)
            make.leading.greaterThanOrEqualTo(companyNameLabel.snp.trailing).offset(8)
            make.trailing.equalTo(stockPriceLabel)
        }

        separatorView.snp.makeConstraints { make in
            make.leading.equalTo(logoImageView)
            make.trailing.equalTo(stockPriceLabel)
            make.bottom.equalToSuperview()
            make.height.equalTo(Const.separatorViewHeight)
        }
    }

    // MARK: - Inner Types

    private enum Const {
        static let logoCornerRadius: CGFloat = logoHeight / 2
        static let logoHeight: CGFloat = 40.0
        static let separatorViewHeight: CGFloat = 1.0
    }
}
