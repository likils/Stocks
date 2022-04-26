// ----------------------------------------------------------------------------
//
//  CompanyDetailsViewController.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine
import CombineCocoa
import StocksData
import StocksSystem
import UIKit

// ----------------------------------------------------------------------------

final class CompanyDetailsViewController: UITableViewController {

    // MARK: - Subviews

    private let companyNewsHeaderView = UIView() <- { view in
        UILabel() <- { lbl in
            lbl.font = StocksFont.title2
            lbl.text = "Company News"
            lbl.textAlignment = .left

            view.addSubview(lbl)
            lbl.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(Const.inset)
            }
        }
    }
    
    // MARK: - Private Properties

    private let viewModel: CompanyDetailsViewModel
    private var news: [NewsModel] = .empty
    private var subscriptions: Set<AnyCancellable> = .empty
    
    // MARK: - Construction

    init(viewModel: CompanyDetailsViewModel) {
        self.viewModel = viewModel
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTableView()
        setupSubscriptions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.viewModel.beginOnlineTradeUpdates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.viewModel.endOnlineTradeUpdates()
    }

    // MARK: - Actions

    private func reloadNews(with newsModels: [NewsModel]) {
        self.news = newsModels
        self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
    }
    
    // MARK: - Private Methods

    private func setupTableView() {

        self.tableView? <- {
            $0.backgroundColor = .white
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.contentInset = Const.tableViewInsets

            $0.registerCell(CompanyDetailsTableViewCell.self)
            $0.registerCell(NewsTableViewCell.self)
        }
    }

    private func setupSubscriptions() {

        self.viewModel
            .getNewsPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.reloadNews(with: $0) }
            .store(in: &self.subscriptions)
    }

    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never

        UILabel() <- {
            $0.numberOfLines = 2
            $0.textAlignment = .center

            let company = self.viewModel.getCompanyProfileDataModel()

            let ticker = NSMutableAttributedString(
                string: company.ticker,
                attributes: [.font: StocksFont.title3]
            )

            let companyName = NSAttributedString(
                string: "\n\(company.name)",
                attributes: [
                    .font: StocksFont.body,
                    .foregroundColor: StocksColor.secondary
                ]
            )

            ticker.append(companyName)
            $0.attributedText = ticker

            navigationItem.titleView = $0
        }
        
        UIButton() <- {
            $0.setImage(UIImage(named: "btn_navbar_back"), for: .normal)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: $0)

            $0.tapPublisher
                .sink { [weak self] in self?.viewModel.pop() }
                .store(in: &subscriptions)
        }
    }

    private func prepareCompanyDetailsCell(for indexPath: IndexPath) -> UITableViewCell {
        return self.tableView.dequeueReusableCell(CompanyDetailsTableViewCell.self, for: indexPath) <- { cell in

            let companyLogoLink = self.viewModel.getCompanyProfileDataModel().logoLink
            let maxLogoSize = cell.bounds.height

            let cellModel = CompanyDetailsCellModel(
                listener: self,
                timelines: self.viewModel.getCompanyCandlesTimeline(),
                selectedTimeline: CompanyCandlesTimeline.day,
                companyCandlesPublisher: self.viewModel.getCompanyCandlesPublisher(),
                companyProfilePublisher: self.viewModel.getCompanyProfilePublisher(),
                imagePublisher: self.viewModel.getImagePublisher(imageLink: companyLogoLink, imageSize: maxLogoSize),
                onlineTradePublisher: self.viewModel.getOnlineTradePublisher()
            )

            cell.updateView(with: cellModel)
        }
    }

    private func prepareNewsCell(for indexPath: IndexPath) -> UITableViewCell {
        return self.tableView.dequeueReusableCell(NewsTableViewCell.self, for: indexPath) <- { cell in

            let newsModel = self.news[indexPath.row]
            cell.updateView(with: newsModel)

            newsModel.imageLink.map { link in
                let maxImageSize = cell.frame.size.width
                let imagePublisher = self.viewModel.getImagePublisher(imageLink: link, imageSize: maxImageSize)
                cell.subscribeToImageChanges(with: imagePublisher)
            }
        }
    }

    // MARK: - Inner Types

    private enum Const {
        static let headerHeight: CGFloat = 48.0
        static let inset: CGFloat = 16.0
        static let tableViewInsets = UIEdgeInsets(top: 0, left: 0, bottom: -16, right: 0)
    }
}

// MARK: - @protocol UITableViewDelegate

extension CompanyDetailsViewController {

    // MARK: - Methods
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return (indexPath.section == 1) ? indexPath : nil
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let newsModel = self.news[indexPath.row]
        self.viewModel.showNewsArticle(with: newsModel)
    }
}

// MARK: - @protocol UITableViewDataSource

extension CompanyDetailsViewController {

    // MARK: - Methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0) ? 0 : Const.headerHeight
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return (section == 0) ? nil : self.companyNewsHeaderView
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? 1 : self.news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return (indexPath.section == 0)
            ? prepareCompanyDetailsCell(for: indexPath)
            : prepareNewsCell(for: indexPath)
    }
}

// MARK: - @protocol CompanyDetailsTableViewCellListener

extension CompanyDetailsViewController: CompanyDetailsTableViewCellListener {

    // MARK: - Methods

    func timelineButtonDidClick(with timeline: CompanyCandlesTimeline) {
        self.viewModel.updateCompanyCandles(with: timeline)
    }

    func watchlistButtonDidClick() {
        self.viewModel.updateWatchlist()
    }
}
