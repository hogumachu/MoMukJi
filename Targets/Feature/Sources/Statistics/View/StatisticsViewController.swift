//
//  StatisticsViewController.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/26.
//

import Core
import Service
import UserInterface
import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa

final class StatisticsViewController: BaseViewController<StatisticsReactor> {
    
    private let navigationView = NavigationView(frame: .zero)
    private let scrollView = UIScrollView(frame: .zero)
    private let habitChartView = ChartView(frame: .zero)
    private let categoryChartView = ChartView(frame: .zero)
    private let someChartView = ChartView(frame: .zero)
    
    override func setupLayout() {
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeArea.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(habitChartView)
        habitChartView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(view).inset(20)
        }
        
        scrollView.addSubview(categoryChartView)
        categoryChartView.snp.makeConstraints { make in
            make.top.equalTo(habitChartView.snp.bottom).offset(40)
            make.leading.trailing.equalTo(view).inset(20)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    
    override func setupAttributes() {
        view.backgroundColor = .monoblack
        
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
        }
        
        navigationView.do {
            $0.configure(.init(type: .close, title: nil))
        }
        
        habitChartView.do {
            $0.backgroundColor = .blue1
            $0.layer.cornerRadius = 16
        }
        
        categoryChartView.do {
            $0.backgroundColor = .blue1
            $0.layer.cornerRadius = 16
        }
    }
    
    override func bind(reactor: StatisticsReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
}

extension StatisticsViewController {
    
    private func bindAction(reactor: Reactor) {
        rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationView.rx.leftButtonTap
            .map { Reactor.Action.navigationLeftButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: Reactor) {
        reactor.state.map(\.habitChartModel)
            .compactMap { $0?.viewModel }
            .withUnretained(self.habitChartView)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { chartView, model in
                chartView.configure(model)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map(\.categoryChartModel)
            .compactMap { $0?.viewModel }
            .withUnretained(self.categoryChartView)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { chartView, model in
                chartView.configure(model)
            })
            .disposed(by: disposeBag)
    }
    
}

private extension ChartModel {
    
    var viewModel: ChartViewModel {
        return ChartViewModel(charts: charts, description: description)
    }
    
}
