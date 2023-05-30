//
//  FoodDetailViewController.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/29.
//

import Domain
import UserInterface
import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa

final class FoodDetailViewController: BaseViewController<FoodDetailReactor> {
    
    private let navigationView = NavigationView(frame: .zero)
    private let scrollView = UIScrollView(frame: .zero)
    private let stackView = UIStackView(frame: .zero)
    private let mealtimeTitleLabel = UILabel(frame: .zero)
    private let favoriteButtonView = FavoriteFoodButtonsView(frame: .zero)
    private let breakfastView = MealtimeFoldableView(frame: .zero)
    private let lunchView = MealtimeFoldableView(frame: .zero)
    private let dinnerView = MealtimeFoldableView(frame: .zero)
    private let midnightSnackView = MealtimeFoldableView(frame: .zero)
    private let editButton = ActionButton(frame: .zero)
    
    override func setupLayout() {
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeArea.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        view.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeArea.bottom).offset(-10)
            make.height.equalTo(48)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(editButton.snp.top)
        }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalTo(view).inset(20)
            make.bottom.equalToSuperview()
        }
        
        stackView.addArrangedSubview(mealtimeTitleLabel)
        stackView.addArrangedSubview(breakfastView)
        stackView.addArrangedSubview(lunchView)
        stackView.addArrangedSubview(dinnerView)
        stackView.addArrangedSubview(midnightSnackView)
    }
    
    override func setupAttributes() {
        view.backgroundColor = .monoblack
        
        navigationView.do {
            $0.configure(.init(type: .back, title: nil))
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 10
            $0.alignment = .fill
            $0.distribution = .fill
            $0.setCustomSpacing(40, after: favoriteButtonView)
            $0.setCustomSpacing(20, after: mealtimeTitleLabel)
        }
        
        mealtimeTitleLabel.do {
            $0.font = .headerSB
            $0.textColor = .white
        }
    }
    
    override func bind(reactor: FoodDetailReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
}

extension FoodDetailViewController {
    
    private func bindAction(reactor: Reactor) {
        rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationView.rx.leftButtonTap
            .map { Reactor.Action.navigationLeftButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationView.rx.rightButtonTap
            .compactMap { [weak self] in self?.navigationView.model?.type }
            .compactMap { type -> Bool? in
                switch type {
                case .backWithRightButton(let rightType):
                    switch rightType {
                    case .heart:
                        return false
                        
                    case .heartFill:
                        return true
                    }
                    
                default:
                    return nil
                }
            }
            .map(Reactor.Action.navigationRightButtonTap)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        breakfastView.rx.foldableButtonTap
            .map { Reactor.Action.foldableButtonTap(.breakfast) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        lunchView.rx.foldableButtonTap
            .map { Reactor.Action.foldableButtonTap(.lunch) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        dinnerView.rx.foldableButtonTap
            .map { Reactor.Action.foldableButtonTap(.dinner) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        midnightSnackView.rx.foldableButtonTap
            .map { Reactor.Action.foldableButtonTap(.midnightSnack) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        favoriteButtonView.rx.likeButtonTap
            .map { Reactor.Action.likeButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        favoriteButtonView.rx.dislikeButtonTap
            .map { Reactor.Action.dislikeButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: Reactor) {
        reactor.state.map(\.isFavorite)
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { this, isFavorite in this.updateFavorite(isFavorite: isFavorite)} )
            .disposed(by: disposeBag)
        
        reactor.state.map(\.favoriteTitle)
            .bind(to: favoriteButtonView.rx.title)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.mealtimeTitle)
            .bind(to: mealtimeTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.breakfast)
            .compactMap { $0 }
            .bind(to: breakfastView.rx.model)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.lunch)
            .compactMap { $0 }
            .bind(to: lunchView.rx.model)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.dinner)
            .compactMap { $0 }
            .bind(to: dinnerView.rx.model)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.midnightSnack)
            .compactMap { $0 }
            .bind(to: midnightSnackView.rx.model)
            .disposed(by: disposeBag)
    }
    
    private func updateFavorite(isFavorite: Bool?) {
        guard let isFavorite else {
            insertFavoriteButtonViewIfEnabled()
            return
        }
        hideFavoriteButtonView(isFavorite)
    }
    
    private func insertFavoriteButtonViewIfEnabled() {
        if stackView.subviews.contains(where: { $0 == favoriteButtonView }) == false {
            stackView.insertArrangedSubview(favoriteButtonView, at: 0)
        }
    }
    
    private func hideFavoriteButtonView(_ isFavorite: Bool) {
        let model = NavigationViewModel(type: .backWithRightButton(isFavorite ? .heartFill : .heart), title: nil)
        if case .backWithRightButton = navigationView.model?.type {
            UIView.animate(
                withDuration: 0.2,
                delay: .zero,
                options: [.curveEaseInOut],
                animations: { [weak self] in
                    self?.navigationView.configure(model)
                })
        } else {
            UIView.animate(
                withDuration: 0.2,
                delay: .zero,
                options: [.curveEaseInOut],
                animations: { [weak self] in
                    self?.favoriteButtonView.alpha = 0.0
                },
                completion: { [weak self] _ in
                    UIView.animate(withDuration: 0.2) {
                        self?.favoriteButtonView.isHidden = true
                        self?.navigationView.configure(model)
                    }
                })
        }
    }
    
}
