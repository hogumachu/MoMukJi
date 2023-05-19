//
//  IntroViewController.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/18.
//

import UserInterface
import UIKit
import RxSwift
import ReactorKit
import Then

final class IntroViewController: BaseViewController<IntroReactor> {
    
    private let homeButton = UIButton(frame: .zero)
    
    override func setupLayout() {
        view.addSubview(homeButton)
        homeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeArea.bottom).offset(-10)
            make.height.equalTo(48)
        }
    }
    
    override func setupAttributes() {
        view.backgroundColor = .white
        
        homeButton.do {
            $0.backgroundColor = .systemPink
            $0.layer.cornerRadius = 16
            $0.setTitle("홈으로", for: .normal)
        }
    }
    
    override func bind(reactor: IntroReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
}

// MARK: - Bind
extension IntroViewController {
    
    private func bindAction(reactor: IntroReactor) {
        homeButton.rx.tap
            .map { Reactor.Action.homeButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: IntroReactor) {
        
    }
    
}
