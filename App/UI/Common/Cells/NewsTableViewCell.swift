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

    private let backView = CellBackgroundView()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .Text.secondaryColor
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .Text.secondaryColor
        return label
    }()
    
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let summaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .Text.primaryColor
        label.numberOfLines = 3
        return label
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()

// MARK: - Private Properties

    private let relativeDateFormatter = RelativeDateTimeFormatter()
    private var thumbnailImageSubscriber: AnyCancellable?
    
    // MARK: - Construction
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods

    override func prepareForReuse() {
        super.prepareForReuse()

        thumbnailImageSubscriber?.cancel()
    }

    func setNews(_ news: NewsModel) {
        dateLabel.text = relativeDateFormatter.localizedString(for: news.date, relativeTo: Date())
        sourceLabel.text = news.source
        headlineLabel.text = news.headline
        summaryLabel.text = news.summary
        thumbnailImageView.image = UIImage()
    }
    
    func subscribeToImageChanges(with imagePublisher: ImagePublisher?) {
        thumbnailImageSubscriber?.cancel()

        thumbnailImageSubscriber = imagePublisher?
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.thumbnailImageView.image = $0 }
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
        
        backView.addSubview(sourceLabel)
        backView.addSubview(dateLabel)
        backView.addSubview(headlineLabel)
        backView.addSubview(summaryLabel)
        backView.addSubview(thumbnailImageView)
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            sourceLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 16),
            sourceLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 16),
            
            dateLabel.centerYAnchor.constraint(equalTo: sourceLabel.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: sourceLabel.trailingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: backView.trailingAnchor, constant: -8),
            
            headlineLabel.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor, constant: 8),
            headlineLabel.leadingAnchor.constraint(equalTo: sourceLabel.leadingAnchor),
            headlineLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),
            
            summaryLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 8),
            summaryLabel.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor),
            summaryLabel.trailingAnchor.constraint(equalTo: headlineLabel.trailingAnchor),
            
            thumbnailImageView.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 8),
            thumbnailImageView.leadingAnchor.constraint(equalTo: summaryLabel.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: summaryLabel.trailingAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -16),
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor, multiplier: 0.5)
        ])
    }
    
}
