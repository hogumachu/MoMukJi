//
//  HomeViewController.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/19.
//

import Core
import UserInterface
import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import RxDataSources
import SnapKit
import Then

final class HomeViewController: BaseViewController<HomeReactor> {
    
    typealias Section = RxCollectionViewSectionedReloadDataSource<HomeSection>
    
    private let addButton = ActionButton(frame: .zero)
    private let collectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = EmptiableCollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    private lazy var dataSource = Section { section, collectionView, indexPath, item in
        guard let cell = collectionView.dequeueCell(HomeCollectionViewCell.self, for: indexPath) else {
            return UICollectionViewCell()
        }
        cell.configure(item)
        return cell
    }
    
    override func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeArea.bottom).offset(-10)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(48)
            make.width.equalTo(100)
        }
    }
    
    override func setupAttributes() {
        view.backgroundColor = .white
        
        collectionViewFlowLayout.do {
          $0.itemSize = .init(width: view.frame.width, height: 100)
          $0.scrollDirection = .vertical
          $0.minimumLineSpacing = 10
        }
        
        collectionView.do {
            $0.backgroundColor = .white
            $0.register(HomeCollectionViewCell.self)
            $0.configure(.init(title: "추가된 음식이 없어요", description: "새로운 음식을 추가해주세요"))
        }
        
        addButton.do {
            $0.style = .normal
            $0.setTitle("추가", for: .normal)
        }
    }
    
    override func bind(reactor: HomeReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
}

extension HomeViewController {
    
    private func bindAction(reactor: Reactor) {
        rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .map { Reactor.Action.addButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: Reactor) {
        reactor.state.map(\.sections)
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map(\.sections)
            .map { $0.isEmpty == false }
            .bind(to: collectionView.rx.isEmptyViewHidden)
            .disposed(by: disposeBag)
    }
    
}

extension HomeViewController: Refreshable {
    
    func refresh() {
        reactor?.action.onNext(.refresh)
    }
    
}
