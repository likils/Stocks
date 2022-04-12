// ----------------------------------------------------------------------------
//
//  NewsViewModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import StocksSystem
import UIKit

// ----------------------------------------------------------------------------

protocol SettingsViewInput: AnyObject {

    // MARK: - Methods

    func updateView(with types: [SettingsType])
}

// ----------------------------------------------------------------------------

protocol SettingsViewOutput {

    // MARK: - Methods

    func viewDidLoad()

    func cellTapped(with type: SettingsType)
}

// ----------------------------------------------------------------------------

final class SettingsViewController: UITableViewController {

    // MARK: - Private Properties

    private let viewOutput: SettingsViewOutput
    private var settingsType: [SettingsType] = .empty

    // MARK: - Construction

    init(viewOutput: SettingsViewOutput) {
        self.viewOutput = viewOutput
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"

        setupTableView()
        self.viewOutput.viewDidLoad()
    }

    // MARK: - Private Methods

    private func setupTableView() {

        self.tableView? <- {
            $0.backgroundColor = .white
            $0.isScrollEnabled = false
            $0.separatorInset = Const.tableViewSeparatorInsets
            $0.registerCell(UITableViewCell.self)
        }
    }

    // MARK: - Inner Types

    private enum Const {
        static let tableViewSeparatorInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

// MARK: - @protocol UITableViewDelegate

extension SettingsViewController {

    // MARK: - Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let settingsType = settingsType[indexPath.row]
        self.viewOutput.cellTapped(with: settingsType)
    }
}

// MARK: - @protocol UITableViewDataSource

extension SettingsViewController {

    // MARK: - Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.settingsType.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(UITableViewCell.self, for: indexPath)
        cell?.backgroundColor = StocksColor.background

        let settingsType = self.settingsType[indexPath.row]

        switch settingsType {
            case .reset(let title):
                cell?.textLabel?.text = title
        }

        return cell ?? UITableViewCell()
    }
}

// MARK: - @protocol SettingsViewInput

extension SettingsViewController: SettingsViewInput {

    // MARK: - Methods

    func updateView(with types: [SettingsType]) {
        self.settingsType = types
        self.tableView.reloadData()
    }
}
