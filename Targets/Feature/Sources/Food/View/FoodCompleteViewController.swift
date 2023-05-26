//
//  FoodCompleteViewController.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/26.
//

import Domain
import UserInterface
import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa

final class FoodCompleteViewController: BaseViewController<FoodCompleteReactor> {
    
    private let successView = SuccessView(frame: .zero)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func setupLayout() {
        view.addSubview(successView)
        successView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setupAttributes() {
        view.backgroundColor = .monoblack
    }
    
    override func bind(reactor: FoodCompleteReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
}

extension FoodCompleteViewController {
    
    private func bindAction(reactor: Reactor) {
        rx.viewWillAppear
            .withUnretained(self.successView)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { view, _ in view.play(delay: 2) })
            .disposed(by: disposeBag)
        
        successView.animationComplete
            .map { Reactor.Action.animationFinished }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: Reactor) {
        reactor.state.map(\.title)
            .bind(to: successView.rx.title)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.subtitle)
            .bind(to: successView.rx.subtitle)
            .disposed(by: disposeBag)
    }
    
}
