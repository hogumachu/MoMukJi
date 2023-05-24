//
//  ToastView.swift
//  UserInterface
//
//  Created by 홍성준 on 2023/05/21.
//

import UIKit
import SnapKit
import Then

public struct ToastModel {
    
    let message: String
    let type: ToastType
    
    public init(message: String, type: ToastType) {
        self.message = message
        self.type = type
    }
    
}

public enum ToastType {
    
    case normal
    case success
    case fail
    
}

final class ToastView: UIView {
    
    private let containerView = UIView(frame: .zero)
    private let messageLabel = UILabel(frame: .zero)
    private let imageView = UIImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(_ model: ToastModel) {
        messageLabel.text = model.message
        
        switch model.type {
        case .normal:
            imageView.image = UIImage(systemName: "checkmark.circle")?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = .white
            
        case .success:
            imageView.image = UIImage(systemName: "checkmark.circle.fill")?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = .systemGreen
            
        case .fail:
            imageView.image = UIImage(systemName: "xmark.circle.fill")?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = .systemRed
        }
        
        self.containerView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupLayout() {
        addSubview(containerView)
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.top.leading.bottom.equalToSuperview()
        }
        
        containerView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(5)
            make.centerY.trailing.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        clipsToBounds = true
        backgroundColor = .white.withAlphaComponent(0.3)
        layer.cornerRadius = 8
        
        imageView.do {
            $0.image = UIImage(systemName: "checkmark.circle")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .white
        }
        
        messageLabel.do {
            $0.textColor = .white
            $0.font = .captionSB
        }
    }
    
}
