//
//  ToastView.swift
//  UserInterface
//
//  Created by 홍성준 on 2023/05/21.
//

import UIKit
import SnapKit
import Then
import Lottie

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
    private let imageView = LottieAnimationView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func play() {
        imageView.play()
    }
    
    public func stop() {
        imageView.stop()
    }
    
    public func configure(_ model: ToastModel) {
        messageLabel.text = model.message
        
        switch model.type {
        case .normal:
            imageView.animation = LottieAnimation.named("lottie-check")
            backgroundColor = .green.withAlphaComponent(0.3)
            
        case .success:
            imageView.animation = LottieAnimation.named("lottie-check")
            backgroundColor = .green.withAlphaComponent(0.3)
            
        case .fail:
            imageView.animation = LottieAnimation.named("lottie-x-mark")
            backgroundColor = .red.withAlphaComponent(0.3)
        }
        
        self.containerView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupLayout() {
        addSubview(containerView)
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 35, height: 35))
            make.top.leading.bottom.equalToSuperview()
        }
        
        containerView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing)
            make.centerY.trailing.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        clipsToBounds = true
        backgroundColor = .white.withAlphaComponent(0.3)
        layer.cornerRadius = 16
        
        imageView.do {
            $0.backgroundColor = .clear
            $0.contentMode = .scaleAspectFit
            $0.loopMode = .playOnce
        }
        
        messageLabel.do {
            $0.textColor = .white
            $0.font = .bodySB
        }
    }
    
}
