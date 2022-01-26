// ----------------------------------------------------------------------------
//
//  NewsTableViewCell.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine
import UIKit

// ----------------------------------------------------------------------------

final class NewsTableViewCell: UITableViewCell {

// MARK: - Subviews

    private let defaultBackgroundView = DefaultBackgroundView()

    private let sourceLabel = UILabel() <- {
        $0.font = Font.link
        $0.textColor = Color.secondary
    }

    private let dateLabel = UILabel() <- {
        $0.font = Font.subhead
        $0.textColor = Color.secondary
    }

    private let headlineLabel = UILabel() <- {
        $0.font = Font.title2
        $0.numberOfLines = 3
    }

    private let summaryLabel = UILabel() <- {
        $0.font = Font.body
        $0.textColor = Color.primary
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
        super.prepareForReuse()

        thumbnailImageSubscriber?.cancel()
    }

    func updateView(with newsModel: NewsModel) {
        sourceLabel.text = newsModel.source
        dateLabel.text = newsModel.date.relativeDateTime
        headlineLabel.text = newsModel.headline
        summaryLabel.text = newsModel.summary
    }

    func subscribeToImageChanges(with imagePublisher: ImagePublisher) {
        thumbnailImageSubscriber?.cancel()

        thumbnailImageSubscriber = imagePublisher
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
            make.top.leading.equalToSuperview().inset(Const.inset)
        }

        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(sourceLabel)
            make.leading.equalTo(sourceLabel.snp.trailing).offset(Const.offset)
            make.trailing.lessThanOrEqualToSuperview().inset(Const.inset)
        }

        headlineLabel.snp.makeConstraints { make in
            make.top.equalTo(sourceLabel.snp.bottom).offset(Const.offset)
            make.leading.equalTo(sourceLabel)
            make.trailing.equalToSuperview().inset(Const.inset)
        }

        summaryLabel.snp.makeConstraints { make in
            make.top.equalTo(headlineLabel.snp.bottom).offset(Const.offset)
            make.leading.trailing.equalTo(headlineLabel)
        }

        thumbnailImageView.snp.makeConstraints { make in
            make.top.equalTo(summaryLabel.snp.bottom).offset(Const.offset)
            make.leading.trailing.equalTo(summaryLabel)
            make.bottom.equalToSuperview().inset(Const.inset)
            make.height.equalTo(thumbnailImageView.snp.width).dividedBy(2)
        }
    }

// MARK: - Inner Types

    private enum Const {
        static let backgroundEdgeInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        static let inset: CGFloat = 16.0
        static let offset: CGFloat = 8.0
    }
}
