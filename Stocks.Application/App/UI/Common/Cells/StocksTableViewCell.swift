// ----------------------------------------------------------------------------
//
//  StocksTableViewCell.swift
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

final class StocksTableViewCell: UITableViewCell {

// MARK: - Subviews

    private let defaultBackgroundView = DefaultBackgroundView()

    private let logoImageView = UIImageView() <- {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = Const.logoCornerRadius
    }

    private let symbolLabel = UILabel() <- {
        $0.font = Font.title3
        $0.setContentCompressionResistancePriority(UILayoutPriority(749), for: .horizontal)
    }

    private let companyLabel = UILabel() <- {
        $0.font = Font.body
        $0.textColor = Color.secondary
        $0.setContentCompressionResistancePriority(UILayoutPriority(749), for: .horizontal)
    }

    private let stockPriceLabel = UILabel() <- {
        $0.font = Font.body
        $0.textAlignment = .right
        $0.layer.cornerRadius = 4
    }

    private let priceDiffLabel = UILabel() <- {
        $0.font = Font.body
        $0.textAlignment = .right
    }

// MARK: - Private Properties

    private var currencySymbol: String = .empty
    private var currentPrice: Double = .nan
    private var previousClosePrice: Double = .nan

    private var logoImageSubscriber: AnyCancellable?
    private var onlineTradeSubscriber: AnyCancellable?

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
        self.logoImageSubscriber?.cancel()
        self.onlineTradeSubscriber?.cancel()

        super.prepareForReuse()
    }

    func updateView(with companyProfile: CompanyProfileModel) {

        self.symbolLabel.text = companyProfile.tickerSymbol
        self.companyLabel.text = companyProfile.name

        self.currencySymbol = companyProfile.currency.symbol

        let companyQuotes = companyProfile.companyQuotes
        self.previousClosePrice = companyQuotes.previousClosePrice

        let currentPrice = companyQuotes.currentPrice
        updatePrice(currentPrice)
    }

    func subscribeToImageChanges(with imagePublisher: ImagePublisher) {
        self.logoImageSubscriber = imagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.logoImageView.image = $0 }
    }

    func subscribeToOnlineTrade(with onlineTradePublisher: OnlineTradePublisher) {
        self.onlineTradeSubscriber = onlineTradePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.updatePrice($0.price) }
    }

// MARK: - Private Methods

    private func updatePrice(_ newPrice: Double) {

        guard self.currentPrice.textRepresentation != newPrice.textRepresentation else { return }

        self.stockPriceLabel.text = newPrice.textRepresentation + " " + self.currencySymbol

        let priceColor = (self.currentPrice > newPrice) ? Color.negativePrice : Color.positivePrice
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
        self.priceDiffLabel.textColor = (priceDiff < 0) ? Color.negativePrice : Color.positivePrice
    }

    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(defaultBackgroundView)

        defaultBackgroundView.addSubview(logoImageView)
        defaultBackgroundView.addSubview(symbolLabel)
        defaultBackgroundView.addSubview(companyLabel)
        defaultBackgroundView.addSubview(stockPriceLabel)
        defaultBackgroundView.addSubview(priceDiffLabel)

        setupConstraints()
    }

    private func setupConstraints() {

        defaultBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Const.backgroundEdgeInset)
        }

        logoImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(Const.inset)
            make.height.equalTo(logoImageView.snp.width)
            make.height.equalTo(Const.logoHeight)
        }

        symbolLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView)
            make.leading.equalTo(logoImageView.snp.trailing).offset(Const.offset)
        }

        companyLabel.snp.makeConstraints { make in
            make.leading.equalTo(symbolLabel)
            make.bottom.equalTo(logoImageView)
        }

        stockPriceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(symbolLabel)
            make.leading.greaterThanOrEqualTo(symbolLabel.snp.trailing).offset(Const.offset)
            make.trailing.equalToSuperview().inset(Const.inset)
        }

        priceDiffLabel.snp.makeConstraints { make in
            make.centerY.equalTo(companyLabel)
            make.leading.greaterThanOrEqualTo(companyLabel.snp.trailing).offset(Const.offset)
            make.trailing.equalTo(stockPriceLabel)
        }
    }

// MARK: - Inner Types

    private enum Const {
        static let backgroundEdgeInset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        static let inset: CGFloat = 16.0
        static let logoCornerRadius: CGFloat = logoHeight / 2
        static let logoHeight: CGFloat = 40.0
        static let offset: CGFloat = 8.0
    }
}
