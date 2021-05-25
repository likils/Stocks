//
//  SettingsVC.swift
//  Stocks
//
//  Created by likils on 27.04.2021.
//

import UIKit

class SettingsVC: UITableViewController {
    
    // MARK: - Dimensions
    static private let inset: CGFloat = 16
    
    // MARK: - Private properties
    private let viewModel: SettingsViewModel
    
    // MARK: - Init
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifesycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        
        setupTableView()
    }
    
    // MARK: - Private methods
    private func setupTableView() {
        tableView.backgroundColor = .View.backgroundColor
        tableView.isScrollEnabled = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: Self.inset, bottom: 0, right: Self.inset)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        let cellData = viewModel.cells[indexPath.row]
        switch cellData {
            case .logout(let title):
                cell.textLabel?.text = title
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = viewModel.cells[indexPath.row]
        viewModel.cellTapped(cell)
    }
    
}
