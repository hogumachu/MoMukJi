//
//  LoadingView.swift
//  UserInterface
//
//  Created by 홍성준 on 2023/05/25.
//

import UIKit
import SnapKit
import Then
import Lottie

public final class LoadingView: UIView {
    
    private let loadingView = LottieAnimationView(name: "lottie-loading")
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func play() {
        loadingView.play()
    }
    
    public func stop() {
        loadingView.stop()
    }
    
    private func setupLayout() {
        addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(300)
        }
    }
    
    private func setupAttributes() {
        loadingView.do {
            $0.backgroundColor = .clear
            $0.contentMode = .scaleAspectFit
            $0.loopMode = .loop
        }
    }
    
}
