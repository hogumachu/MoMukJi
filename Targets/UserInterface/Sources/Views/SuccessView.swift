//
//  SuccessView.swift
//  UserInterface
//
//  Created by 홍성준 on 2023/05/26.
//

import UIKit
import SnapKit
import Then
import Lottie
import RxSwift
import RxCocoa
import RxRelay

public final class SuccessView: UIView {
    
    public var animationComplete: Observable<Void> {
        animationCompleteRelay.asObservable()
    }
    private let animationCompleteRelay = PublishRelay<Void>()
    private let stackView = UIStackView(frame: .zero)
    private let checkAnimationView = LottieAnimationView(name: "lottie-check-large")
    public let titleLabel = UILabel(frame: .zero)
    public let subtitleLabel = UILabel(frame: .zero)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func play(delay: CGFloat = .zero) {
        checkAnimationView.play { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self?.animationCompleteRelay.accept(())
            }
        }
    }
    
    public func stop() {
        checkAnimationView.stop()
    }
    
    public func setupLayout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.centerY.equalToSuperview()
        }
        
        checkAnimationView.snp.makeConstraints { make in
            make.size.equalTo(250)
        }
        
        stackView.addArrangedSubview(checkAnimationView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
    }
    
    public func setupAttributes() {
        backgroundColor = .monoblack
        
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 5
            $0.setCustomSpacing(30, after: checkAnimationView)
            $0.distribution = .fill
            $0.alignment = .center
        }
        
        checkAnimationView.do {
            $0.backgroundColor = .clear
            $0.contentMode = .scaleAspectFit
            $0.loopMode = .playOnce
        }
        
        titleLabel.do {
            $0.font = .headerB
            $0.textColor = .white
            $0.textAlignment = .center
        }
        
        subtitleLabel.do {
            $0.font = .bodySB
            $0.textColor = .monogray2
            $0.textAlignment = .center
        }
    }
    
}

public extension Reactive where Base: SuccessView {
    
    var title: Binder<String?> {
        return base.titleLabel.rx.text
    }
    
    var subtitle: Binder<String?> {
        return base.subtitleLabel.rx.text
    }
    
}

