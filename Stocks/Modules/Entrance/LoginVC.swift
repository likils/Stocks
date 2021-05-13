//
//  LoginVC.swift
//  Stocks
//
//  Created by likils on 27.04.2021.
//

import UIKit

class LoginVC: UIViewController {
    
    // MARK: - Subviews
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "S T O C K S"
        label.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private let appleButton = SocialButton(socialType: .apple)
    private let googleButton = SocialButton(socialType: .google)
    private let facebookButton = SocialButton(socialType: .facebook)
    
    // MARK: - Private properties
    private let viewModel: LoginViewModel
    
    // MARK: - Init
    init(viewModel: LoginViewModel) {
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
        
        appleButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        facebookButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc func loginTapped(selector: SocialButton) {
        viewModel.login(with: selector.socialType)
    }
    
    // MARK: - Private methods
    private func setupView() {
        view.backgroundColor = .View.backgroundColor
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(label)
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(appleButton)
        stackView.addArrangedSubview(googleButton)
        stackView.addArrangedSubview(facebookButton)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
    }
    
}
