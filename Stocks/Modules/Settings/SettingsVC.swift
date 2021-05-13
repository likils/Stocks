//
//  SettingsVC.swift
//  Stocks
//
//  Created by likils on 27.04.2021.
//

import UIKit

class SettingsVC: UIViewController {
    
    // MARK: - Subviews
    private let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 3
        button.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Private properties
    private let viewModel: SettingsViewModel
    
    // MARK: - Init
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifesycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Actions
    @objc func logoutTapped() {
        viewModel.logout()
    }
    
    // MARK: - Private methods
    private func setupView() {
        view.backgroundColor = .View.backgroundColor
        navigationController?.isNavigationBarHidden = true
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
}
