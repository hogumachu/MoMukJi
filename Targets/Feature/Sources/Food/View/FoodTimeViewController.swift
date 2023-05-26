//
//  FoodTimeViewController.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/25.
//

import Core
import UserInterface
import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxDataSources

final class FoodTimeViewController: BaseViewController<FoodTimeReactor> {
    
    private let navigationView = NavigationView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let containerView = UIView(frame: .zero)
    private let stackView = UIStackView(frame: .zero)
    private let buttons: [FoodTimeButton] = FoodTimeButtonModel.allCases.map { model in
        let timeButton = FoodTimeButton(frame: .zero)
        timeButton.configure(model)
        timeButton.layer.cornerRadius = 16
        timeButton.isUserInteractionEnabled = true
        return timeButton
    }
    
    override func setupLayout() {
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeArea.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        view.insertSubview(containerView, belowSubview: navigationView)
        containerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeArea.bottom)
        }
        
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.centerY.equalToSuperview().inset(20)
        }
        
        stackView.addArrangedSubview(titleLabel)
        buttons.forEach { stackView.addArrangedSubview($0) }
    }
    
    override func setupAttributes() {
        view.backgroundColor = .monoblack
        
        navigationView.do {
            $0.configure(.init(type: .back, title: nil))
        }
        
        titleLabel.do {
            $0.textColor = .white
            $0.font = .headerB
            $0.text = "언제 드셨나요?"
            $0.textAlignment = .center
        }
        
        containerView.do {
            $0.backgroundColor = .monoblack
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 20
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.setCustomSpacing(30, after: titleLabel)
        }
    }
    
    override func bind(reactor: FoodTimeReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
}

extension FoodTimeViewController {
    
    private func bindAction(reactor: Reactor) {
        navigationView.rx.leftButtonTap
            .map { Reactor.Action.navigationLeftButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        buttons.forEach { button in
            button.rx.tapWithModel
                .compactMap { $0 }
                .map(Reactor.Action.timeButtonTap)
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
    }
    
    private func bindState(reactor: Reactor) {
        
    }
    
}
