//
//  SocialButton.swift
//  Stocks
//
//  Created by likils on 30.04.2021.
//

import UIKit

class SocialButton: UIButton {
    
    // MARK: - Subviews
    private let socialImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Public properties
    let socialType: SocialType
    
    // MARK: - Construction
    init(socialType: SocialType) {
        self.socialType = socialType
        super.init(frame: CGRect.zero)
        setupView(with: socialType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupView(with type: SocialType) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        layer.cornerRadius = 10
        
        setTitle(type.loginTitle, for: .normal)
        setTitleColor(type.titleColor, for: .normal)
        
        backgroundColor = type.backgroundColor
        socialImageView.image = type.logo
        
        addSubview(socialImageView)
        
        NSLayoutConstraint.activate([
            socialImageView.centerYAnchor.constraint(equalTo: titleLabel!.centerYAnchor, constant: -1),
            socialImageView.trailingAnchor.constraint(equalTo: titleLabel!.leadingAnchor, constant: -8),
            
            socialImageView.heightAnchor.constraint(equalTo: titleLabel!.heightAnchor, multiplier: 0.32),
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
