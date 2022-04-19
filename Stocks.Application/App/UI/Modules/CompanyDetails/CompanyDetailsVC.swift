//
//  CompanyDetailsVC.swift
//  Stocks
//
//  Created by likils on 25.05.2021.
//

import StocksData
import UIKit

class CompanyDetailsVC: UITableViewController, CompanyDetailsView, CompanyDetailsCellDelegate {
    
    private let newsHeaderLabel: UIView = {
        let view = UIView()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Company News"
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        return view
    }()
    
    // MARK: - Dimensions
    static private let inset: CGFloat = 16
    static private let tableContentInsets = UIEdgeInsets(top: 0, left: 0, bottom: -inset, right: 0)
    static private let headerHeight: CGFloat = 48
    
    // MARK: - Private Properties
    private let viewModel: CompanyDetailsViewModel
    private var company: CompanyProfileModel {
        viewModel.companyProfile
    }
    private var news: [NewsModel] {
        viewModel.news
    }
    
    // MARK: - Construction
    init(viewModel: CompanyDetailsViewModel) {
        self.viewModel = viewModel
        super.init(style: .grouped)
        viewModel.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        
        viewModel.getNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTimeline(viewModel.initTimeline)
        viewModel.onlineUpdateBegin()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.onlineUpdateEnd()
    }
    
    // MARK: - Actions
    @objc func close() {
        viewModel.close()
    }
    
    // MARK: - Public Methods
    
    // MARK: Company details cell delegate
    func updateWatchlist() {
        viewModel.updateWatchlist()
    }
    
    func updateTimeline(_ timeline: CompanyCandlesTimeline) {
        viewModel.getCandles(withTimeline: timeline)
    }
    
    // MARK: Detail View
    func updateValues(by candles: CompanyCandlesModel?, and timeline: CompanyCandlesTimeline) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CompanyDetailsTableViewCell else { return }
        cell.updateValues(by: candles, and: timeline)
    }
    
    func updateQuotes() {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CompanyDetailsTableViewCell else { return }
        cell.companyQuotes = company.companyQuotes
    }
    
    // MARK: News
    func showNews() {
        tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
    }
    
    // MARK: - Private Methods
    private func setupNavBar() {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        let text1 = NSMutableAttributedString(string: company.ticker, attributes: [.font : UIFont.systemFont(ofSize: 16, weight: .semibold)])
        let text2 = NSAttributedString(string: "\n\(company.name)", attributes: [.font : UIFont.systemFont(ofSize: 14, weight: .semibold),
                                                                                 .foregroundColor: StocksColor.secondary])
        text1.append(text2)
        label.attributedText = text1
        
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "btn_navbar_back"), for: .normal)
        backButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        navigationItem.titleView = label
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupTableView() {
        tableView.backgroundColor = StocksColor.background
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = Self.tableContentInsets
        tableView.register(CompanyDetailsTableViewCell.self, forCellReuseIdentifier: CompanyDetailsTableViewCell.identifier)
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
    }
    
}

// MARK: - TableView Delegate & Datasource
extension CompanyDetailsVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? 0 : Self.headerHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        section == 0 ? nil : newsHeaderLabel
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0,
           let cell = tableView.dequeueReusableCell(withIdentifier: CompanyDetailsTableViewCell.identifier, for: indexPath) as? CompanyDetailsTableViewCell {
            cell.updateCompanyDetails(by: company)
//            cell.companyQuotes = company.companyQuotes
            cell.delegate = self
            let publisher = viewModel.requestLogoImage()
            cell.subscribeToImageChanges(with: publisher)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath)
            if let cell = cell as? NewsTableViewCell {
                let news = news[indexPath.row]
                cell.updateView(with: news)
                
                let maxImageSize = Double(cell.frame.size.width)
                let publisher = viewModel.requestNewsImage(withSize: maxImageSize, for: indexPath)
                cell.subscribeToImageChanges(with: publisher)
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard indexPath.section == 1 else { return nil }

        viewModel.cellTapped(at: indexPath.row)
        return indexPath
    }
    
}
