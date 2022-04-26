// ----------------------------------------------------------------------------
//
//  CompanyDetailsTableViewCell.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine
import StocksData
import StocksNetwork
import StocksSystem
import UIKit

// ----------------------------------------------------------------------------

protocol CompanyDetailsTableViewCellListener: AnyObject {

    // MARK: - Methods

    func timelineButtonDidClick(with timeline: CompanyCandlesTimeline)

    func watchlistButtonDidClick()
}

// ----------------------------------------------------------------------------

final class CompanyDetailsTableViewCell: UITableViewCell {

    // MARK: - Subviews

    private let logoImageView = UIImageView() <- {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = Const.logoCornerRadius
    }

    private let stockPriceLabel = UILabel() <- {
        $0.font = StocksFont.title3
    }

    private let exchangeLabel = UILabel() <- {
        $0.font = StocksFont.body
        $0.textColor = StocksColor.secondary
    }

    private let watchlistButton = UIButton() <- {
        $0.isEnabled = false
    }

    private let minPriceNameLabel = UILabel() <- {
        $0.font = StocksFont.body
        $0.text = "Min"
    }

    private let minPriceLabel = UILabel() <- {
        $0.font = StocksFont.body
        $0.textColor = StocksColor.negativePrice
    }

    private let maxPriceNameLabel = UILabel() <- {
        $0.font = StocksFont.body
        $0.text = "Max"
    }

    private let maxPriceLabel = UILabel() <- {
        $0.font = StocksFont.body
        $0.textColor = StocksColor.positivePrice
    }

    private let priceDiffLabel = UILabel() <- {
        $0.font = StocksFont.body
    }

    private let graphBackgrounView = UIView() <- {
        $0.backgroundColor = StocksColor.background
        $0.layer.cornerRadius = Const.graphBackgrounViewCornerRadius
    }

    private let timelineButtonsView = TimelineButtonsView()

    private let graphView = GraphView() <- {
        $0.isHidden = true
    }

    private let loadingDataLabel = UILabel() <- {
        $0.font = StocksFont.body
        $0.textColor = StocksColor.secondary
        $0.textAlignment = .center
        $0.text = "Loading..."
    }
    
    // MARK: - Private Properties

    private var companyInWatchlist = false
    private var currencySymbol: String = .empty
    private var currentPrice: Double = .nan
    private var previousClosePrice: Double = .nan

    private var subscriptions: Set<AnyCancellable> = .empty

    private weak var listener: CompanyDetailsTableViewCellListener?
    
    // MARK: - Construction

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    func updateView(with model: CompanyDetailsCellModel) {
        self.listener = model.listener

        setupSubscriptions(with: model)
        updateTimelineButtonsView(with: model)
    }
    
    // MARK: - Private Methods

    private func setupSubscriptions(with model: CompanyDetailsCellModel) {
        model.companyCandlesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.updateCandles($0) }
            .store(in: &self.subscriptions)

        model.companyProfilePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.updateCompanyProfile($0) }
            .store(in: &self.subscriptions)

        model.imagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.logoImageView.image = $0 }
            .store(in: &self.subscriptions)

        model.onlineTradePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.updatePrice($0.price) }
            .store(in: &self.subscriptions)
    }

    private func updateTimelineButtonsView(with model: CompanyDetailsCellModel) {

        let viewModel = TimelineButtonsViewModel(
            timelines: model.timelines,
            selectedTimeline: model.selectedTimeline,
            listener: self
        )
        self.timelineButtonsView.updateView(with: viewModel)

        self.listener?.timelineButtonDidClick(with: viewModel.selectedTimeline)
    }

    private func updateCandles(_ candles: CompanyCandlesModel) {

        candles.openPrices.first.map { price in
            self.previousClosePrice = price
            updatePriceDiff()
        }

        let prices = candles.highPrices.enumerated().map { ($1 + candles.lowPrices[$0]) / 2 }
        let minPrice = candles.lowPrices.min() ?? 0
        let maxPrice = candles.highPrices.max() ?? 0

        let graphModel = GraphModel(prices: prices, minPrice: minPrice, maxPrice: maxPrice)
        self.graphView.updateView(with: graphModel)

        self.minPriceLabel.text = minPrice.textRepresentation.with(self.currencySymbol)
        self.maxPriceLabel.text = maxPrice.textRepresentation.with(self.currencySymbol)

        self.loadingDataLabel.isHidden = true
        self.graphView.isHidden = false
    }

    private func updateCompanyProfile(_ companyProfile: CompanyProfileModel) {
        self.currencySymbol = companyProfile.currency.symbol
        self.exchangeLabel.text = companyProfile.listedExchange
        self.previousClosePrice = companyProfile.companyQuotes.previousClosePrice
        self.companyInWatchlist = companyProfile.inWatchlist

        updatePrice(companyProfile.companyQuotes.currentPrice)
        updateWatchlistButton()
    }

    private func updatePrice(_ newPrice: Double) {

        guard self.currentPrice.textRepresentation != newPrice.textRepresentation else { return }

        self.stockPriceLabel.text = newPrice.textRepresentation.with(self.currencySymbol)
        self.currentPrice = newPrice

        updatePriceDiff()
    }

    private func updatePriceDiff() {

        let priceDiff = self.currentPrice - self.previousClosePrice
        let priceDiffPercent = abs((priceDiff * 100) / self.previousClosePrice)

        let diffText = (priceDiff > 0)
        ? ("+" + priceDiff.textRepresentation)
        : priceDiff.textRepresentation

        self.priceDiffLabel.text = "\(diffText.with(self.currencySymbol)) (\(priceDiffPercent.textRepresentation)%)"
        self.priceDiffLabel.textColor = (priceDiff < 0) ? StocksColor.negativePrice : StocksColor.positivePrice
    }

    private func updateWatchlistButton() {
        let pictureName = self.companyInWatchlist ? "btn_star_filled" : "btn_star"
        self.watchlistButton.setImage(UIImage(named: pictureName), for: .normal)

        self.watchlistButton.isEnabled = true
    }
    
    private func setupView() {
        self.selectionStyle = .none

        self.watchlistButton.tapPublisher
            .sink { [weak self] in
                self?.companyInWatchlist.toggle()
                self?.updateWatchlistButton()
                self?.listener?.watchlistButtonDidClick()
            }
            .store(in: &self.subscriptions)
        
        contentView.addSubview(logoImageView)
        contentView.addSubview(stockPriceLabel)
        contentView.addSubview(exchangeLabel)
        contentView.addSubview(watchlistButton)
        contentView.addSubview(minPriceNameLabel)
        contentView.addSubview(minPriceLabel)
        contentView.addSubview(maxPriceNameLabel)
        contentView.addSubview(maxPriceLabel)
        contentView.addSubview(priceDiffLabel)
        contentView.addSubview(graphBackgrounView)

        graphBackgrounView.addSubview(timelineButtonsView)
        graphBackgrounView.addSubview(graphView)
        graphBackgrounView.addSubview(loadingDataLabel)

        setupConstraints()
    }

    private func setupConstraints() {

        logoImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(Const.inset)
            make.height.equalTo(logoImageView.snp.width)
            make.height.equalTo(Const.logoHeight)
        }

        stockPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView)
            make.leading.equalTo(logoImageView.snp.trailing).offset(Const.smallInset)
        }

        exchangeLabel.snp.makeConstraints { make in
            make.leading.equalTo(stockPriceLabel.snp.leading)
            make.bottom.equalTo(logoImageView.snp.bottom)
        }

        watchlistButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(22)
            make.height.equalTo(watchlistButton.snp.width)
            make.height.equalTo(Const.watchlistButtonHeight)
        }

        minPriceNameLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(24)
            make.leading.equalTo(logoImageView.snp.leading)
        }

        minPriceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(minPriceNameLabel.snp.centerY)
            make.leading.equalTo(minPriceNameLabel.snp.trailing).offset(4)
        }

        maxPriceNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(minPriceLabel.snp.centerY)
            make.leading.equalTo(minPriceLabel.snp.trailing).offset(4)
        }

        maxPriceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(maxPriceNameLabel.snp.centerY)
            make.leading.equalTo(maxPriceNameLabel.snp.trailing).offset(4)
        }

        priceDiffLabel.snp.makeConstraints { make in
            make.centerY.equalTo(maxPriceLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(16)
        }

        graphBackgrounView.snp.makeConstraints { make in
            make.top.equalTo(minPriceNameLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(Const.inset)
            make.bottom.equalToSuperview()
            make.height.equalTo(240)
        }

        timelineButtonsView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }

        graphView.snp.makeConstraints { make in
            make.top.equalTo(timelineButtonsView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        loadingDataLabel.snp.makeConstraints { make in
            make.edges.equalTo(graphView.snp.edges)
        }
    }

    // MARK: - Inner Types

    private enum Const {
        static let graphBackgrounViewCornerRadius: CGFloat = 16.0
        static let logoCornerRadius: CGFloat = logoHeight / 2
        static let logoHeight: CGFloat = 40.0
        static let inset: CGFloat = 16.0
        static let smallInset: CGFloat = 8.0
        static let watchlistButtonHeight: CGFloat = 20.0
    }
}

// MARK: - @protocol TimelineButtonsViewListener

extension CompanyDetailsTableViewCell: TimelineButtonsViewListener {

    // MARK: - Methods

    func buttonDidClick(with timeline: CompanyCandlesTimeline) {
        self.graphView.isHidden = true
        self.loadingDataLabel.isHidden = false

        self.listener?.timelineButtonDidClick(with: timeline)
    }
}

// ----------------------------------------------------------------------------

extension String {

    // MARK: - Methods

    fileprivate func with(_ currencySymbol: Self) -> Self {
        return self + " " + currencySymbol
    }
}
