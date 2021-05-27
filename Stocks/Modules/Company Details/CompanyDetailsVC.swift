//
//  CompanyDetailsVC.swift
//  Stocks
//
//  Created by likils on 25.05.2021.
//

import UIKit

class CompanyDetailsVC: UITableViewController, CompanyDetailsView {
    
    // MARK: - Dimensions
    static private let inset: CGFloat = 16
    static private let tableContentInsets = UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0)
    
    // MARK: - Private properties
    private let viewModel: CompanyDetailsViewModel
    private var company: CompanyProfile {
        viewModel.companyProfile
    }
    private var news: [News] {
        viewModel.news
    }
    
    // MARK: - Init
    init(viewModel: CompanyDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "\(company.name)"
        
        setupTableView()
        viewModel.getCandles(withTimeline: .day(by: .minutes_5))
        viewModel.getNews()
        viewModel.fetchLogo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.onlineUpdateBegin()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.onlineUpdateEnd()
    }
    
    // MARK: - Public methods
    func updateGraph(data: CompanyCandles) {
//        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CompanyDetailsTableViewCell else { return }
        
    }
    
    func updateQuotes() {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CompanyDetailsTableViewCell else { return }
        cell.companyQuotes = company.companyQuotes
    }
    
    func showNews() {
        tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
    }
    
    func showImage(_ image: UIImage, at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell else { return }
        cell.setImage(image)
    }
    
    func showLogo(_ logo: UIImage) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CompanyDetailsTableViewCell else { return }
        cell.setLogo(logo)
    }
    
    // MARK: - Private methods
    private func setupTableView() {
        tableView.backgroundColor = .View.backgroundColor
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0,
           let cell = tableView.dequeueReusableCell(withIdentifier: CompanyDetailsTableViewCell.identifier, for: indexPath) as? CompanyDetailsTableViewCell {
            cell.companyProfile = company
            cell.companyQuotes = company.companyQuotes
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath)
            if let cell = cell as? NewsTableViewCell {
                let news = news[indexPath.row]
                cell.setNews(news)
                
                let maxImageSize = Double(cell.frame.size.width)
                viewModel.fetchImage(withSize: maxImageSize, for: indexPath)
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard indexPath.section == 1,
              let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell
        else { return nil }
        
        cell.animate { [weak self] in
            self?.viewModel.cellTapped(at: indexPath.row)
        }
        return indexPath
    }
    
}
