// ----------------------------------------------------------------------------
//
//  NewsCell.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine
import StocksSystem
import UIKit

// ----------------------------------------------------------------------------

final class NewsCell: UITableViewCell {

    // MARK: - Subviews

    private let defaultBackgroundView = UIView() <- {
        $0.backgroundColor = StocksColor.background
        $0.layer.cornerRadius = 16.0
    }

    private let sourceLabel = UILabel() <- {
        $0.font = StocksFont.link
        $0.textColor = StocksColor.secondary
    }

    private let dateLabel = UILabel() <- {
        $0.font = StocksFont.subhead
        $0.textColor = StocksColor.secondary
    }

    private let headlineLabel = UILabel() <- {
        $0.font = StocksFont.title2
        $0.numberOfLines = 3
    }

    private let summaryLabel = UILabel() <- {
        $0.font = StocksFont.body
        $0.textColor = StocksColor.primary
        $0.numberOfLines = 3
    }

    private let thumbnailImageView = UIImageView() <- {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
    }

    // MARK: - Private Properties

    private var thumbnailImageSubscriber: AnyCancellable?

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
        self.thumbnailImageSubscriber?.cancel()

        super.prepareForReuse()
    }

    func updateView(with news: NewsCellModel) {
        self.sourceLabel.text = news.source
        self.dateLabel.text = news.date.relativeDateTime
        self.headlineLabel.text = news.headline
        self.summaryLabel.text = news.summary
    }

    func subscribeToImageChanges(with imagePublisher: ImagePublisher) {
        self.thumbnailImageSubscriber = imagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.thumbnailImageView.image = $0 }
    }

    // MARK: - Private Methods

    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(defaultBackgroundView)

        defaultBackgroundView.addSubview(sourceLabel)
        defaultBackgroundView.addSubview(dateLabel)
        defaultBackgroundView.addSubview(headlineLabel)
        defaultBackgroundView.addSubview(summaryLabel)
        defaultBackgroundView.addSubview(thumbnailImageView)

        setupConstraints()
    }

    private func setupConstraints() {

        defaultBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Const.backgroundEdgeInset)
        }

        sourceLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }

        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(sourceLabel)
            make.leading.equalTo(sourceLabel.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview().inset(16)
        }

        headlineLabel.snp.makeConstraints { make in
            make.top.equalTo(sourceLabel.snp.bottom).offset(8)
            make.leading.equalTo(sourceLabel)
            make.trailing.equalToSuperview().inset(16)
        }

        summaryLabel.snp.makeConstraints { make in
            make.top.equalTo(headlineLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(headlineLabel)
        }

        thumbnailImageView.snp.makeConstraints { make in
            make.top.equalTo(summaryLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(summaryLabel)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(thumbnailImageView.snp.width).dividedBy(2)
        }
    }

    // MARK: - Inner Types

    private enum Const {
        static let backgroundEdgeInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }
}
