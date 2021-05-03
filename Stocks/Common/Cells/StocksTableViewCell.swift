//
//  StocksTableViewCell.swift
//  Stocks
//
//  Created by likils on 01.05.2021.
//

import UIKit

class StocksTableViewCell: UITableViewCell {
    
    // MARK: - Subviews
    private let companyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(rgb: 0x373737)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Public properties
    static var identifier: String {
        "\(Self.self)"
    }
    
    var company = "" {
        didSet {
            companyLabel.text = company
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
        
        contentView.addSubview(companyLabel)
        NSLayoutConstraint.activate([
            companyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            companyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            companyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            companyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }

}
