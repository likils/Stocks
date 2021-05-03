//
//  NewsTableViewCell.swift
//  Stocks
//
//  Created by likils on 26.04.2021.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    // MARK: - Subviews
    private let backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.12
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowColor = UIColor(rgb: 0x303040).cgColor
        return view
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = UIColor(rgb: 0x9A9CA5)
        label.textAlignment = .left
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(rgb: 0x9A9CA5)
        label.textAlignment = .left
        return label
    }()
    
    private let headLineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let summaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(rgb: 0x373737)
        label.textAlignment = .left
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
    
    // MARK: - Public properties
    static var identifier: String {
        "\(Self.self)"
    }
    
    var id = 0
    var sourceUrl: URL!
    
    var source = "" {
        didSet {
            sourceLabel.text = source
        }
    }
    
    var date = Date() {
        didSet {
            let formatter = RelativeDateTimeFormatter()
            dateLabel.text = formatter.localizedString(for: date, relativeTo: Date())
        }
    }
    
    var headLine = "" {
        didSet {
            headLineLabel.text = headLine
        }
    }
    
    var summary = "" {
        didSet {
            summaryLabel.text = summary
        }
    }
    
    var image = UIImage() {
        didSet {
            thumbnailImageView.image = image
        }
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
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        
        backView.addSubview(sourceLabel)
        backView.addSubview(dateLabel)
        backView.addSubview(headLineLabel)
        backView.addSubview(summaryLabel)
        backView.addSubview(thumbnailImageView)
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            sourceLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 16),
            sourceLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 16),
            
            dateLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: sourceLabel.trailingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: backView.trailingAnchor, constant: -8),
            
            headLineLabel.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor, constant: 8),
            headLineLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 16),
            headLineLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),
            
            summaryLabel.topAnchor.constraint(equalTo: headLineLabel.bottomAnchor, constant: 8),
            summaryLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 16),
            summaryLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),
            
            thumbnailImageView.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 8),
            thumbnailImageView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 16),
            thumbnailImageView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),
            thumbnailImageView.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -16),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 167)
        ])
    }
    
}
