//
//  SocialButton.swift
//  Stocks
//
//  Created by likils on 30.04.2021.
//

import UIKit

class SocialButton: UIButton {
    
    // MARK: - Subviews
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 6
        return stackView
    }()
    
    private let socialImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let socialLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 18.5, weight: .semibold)
        return label
    }()

    // MARK: - Public properties
    let socialType: SocialType
    
    // MARK: - Init
    init(socialType: SocialType) {
        self.socialType = socialType
        super.init(frame: CGRect.zero)
        setupView(with: socialType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupView(with type: SocialType) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        layer.cornerRadius = 10
        
//        setTitle(type.loginTitle, for: .normal)
//        setTitleColor(type.titleColor, for: .normal)
        
        socialLabel.textColor = type.titleColor
        socialLabel.text = type.loginTitle
        
        backgroundColor = type.backgroundColor
        socialImageView.image = type.logo
        
        addSubview(stackView)
        stackView.addArrangedSubview(socialImageView)
        stackView.addArrangedSubview(socialLabel)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 4),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -4),
            
            socialImageView.heightAnchor.constraint(equalTo: socialLabel.heightAnchor, multiplier: 0.32),
            socialImageView.widthAnchor.constraint(equalTo: socialImageView.heightAnchor)
        ])
    }
    
}

// MARK: - SocialTypeImpl
extension SocialButton {
    
    enum SocialType: String {
        
        case apple
        case google
        case facebook
        
        var loginTitle: String {
            switch self {
                case .apple:
                    return "Sign in with Apple"
                case .google:
                    return "Sign in with Google"
                case .facebook:
                    return "Sign in with Facebook"
            }
        }
        
        var titleColor: UIColor {
            switch self {
                case .apple, .google, .facebook:
                    return .white
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
                case .apple:
                    return .black
                case .google:
                    return UIColor(rgb: 0x5385EC)
                case .facebook:
                    return UIColor(rgb: 0x4A67AD)
            }
        }
        
        var logo: UIImage? {
            switch self {
                case .apple:
                    return UIImage(named: "apple")
                case .google:
                    return UIImage(named: "google")
                case .facebook:
                    return UIImage(named: "facebook")
            }
        }
        
    }
    
}
