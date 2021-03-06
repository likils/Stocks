// ----------------------------------------------------------------------------
//
//  CompanySearchCell.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import StocksSystem
import UIKit

// ----------------------------------------------------------------------------

final class CompanySearchCell: UITableViewCell {

    // MARK: - Subviews

    private let companyTickerLabel = UILabel() <- {
        $0.font = StocksFont.title3
    }

    private let inWatchListImageView = UIImageView() <- {
        $0.image = UIImage(named: "ic_watch_list")
        $0.isHidden = true
    }

    private let companyNameLabel = UILabel() <- {
        $0.font = StocksFont.body
        $0.textColor = StocksColor.secondary
    }

    private let separatorView = UIView() <- {
        $0.backgroundColor = StocksColor.separator
    }

    // MARK: - Construction

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func updateView(with company: CompanySearchModel) {
        self.companyTickerLabel.text = company.ticker
        self.companyNameLabel.text = company.name
        self.inWatchListImageView.isHidden = !company.inWatchList
    }

    func updateSeparator(isHidden: Bool) {
        self.separatorView.isHidden = isHidden
    }

    // MARK: - Private Methods

    private func setupView() {
        contentView.addSubview(companyTickerLabel)
        contentView.addSubview(inWatchListImageView)
        contentView.addSubview(companyNameLabel)
        contentView.addSubview(separatorView)

        setupConstraints()
    }

    private func setupConstraints() {

        companyTickerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(16)
        }

        inWatchListImageView.snp.makeConstraints { make in
            make.centerY.equalTo(companyTickerLabel)
            make.leading.equalTo(companyTickerLabel.snp.trailing).offset(4)
            make.height.equalTo(inWatchListImageView.snp.width)
            make.height.equalTo(Const.inWatchListImageViewHeight)
        }

        companyNameLabel.snp.makeConstraints { make in
            make.top.equalTo(companyTickerLabel.snp.bottom)
            make.leading.equalTo(companyTickerLabel)
        }

        separatorView.snp.makeConstraints { make in
            make.leading.equalTo(companyNameLabel)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.height.equalTo(Const.separatorViewHeight)
        }
    }

    // MARK: - Inner Types

    private enum Const {
        static let inWatchListImageViewHeight: CGFloat = 8.0
        static let separatorViewHeight: CGFloat = 1.0
    }
}
