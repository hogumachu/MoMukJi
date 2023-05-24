//
//  CategoryListViewController.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/22.
//

import Core
import UserInterface
import UIKit
import SnapKit
import Then
import ReactorKit
import RxDataSources
import RxSwift
import RxCocoa

final class CategoryListViewController: BaseViewController<CategoryListReactor> {
    
    typealias Section = RxCollectionViewSectionedReloadDataSource<CategorySection>
    
    private let navigationView = NavigationView(frame: .zero)
    private let addButton = ActionButton(frame: .zero)
    private let collectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = EmptiableCollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    private lazy var dataSource = Section { section, collectionView, indexPath, item in
        guard let cell = collectionView.dequeueCell(CategoryListCollectionViewCell.self, for: indexPath) else {
            return UICollectionViewCell()
        }
        cell.configure(item)
        return cell
    }
    
    override func setupLayout() {
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeArea.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeArea.bottom).offset(-10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(addButton.snp.top)
        }
    }
    
    override func setupAttributes() {
        view.backgroundColor = .white
        
        navigationView.do {
            $0.configure(.init(type: .close, title: "카테고리"))
        }
        
        collectionViewFlowLayout.do {
            $0.itemSize = .init(width: (view.frame.width / 2) - 30, height: 60)
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 10
        }
        
        collectionView.do {
            $0.backgroundColor = .white
            $0.register(CategoryListCollectionViewCell.self)
            $0.configure(.init(title: "카테고리가 없어요", description: "새로운 카테고리를 추가해주세요"))
        }
        
        addButton.do {
            $0.style = .normal
            $0.setTitle("카테고리 추가하기", for: .normal)
            $0.layer.cornerRadius = 16
        }
    }
    
    override func bind(reactor: CategoryListReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
}

extension CategoryListViewController {
    
    private func bindAction(reactor: Reactor) {
        rx.viewWillAppear
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .map { Reactor.Action.addButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected(dataSource: dataSource)
            .map(Reactor.Action.itemSelected)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationView.rx.leftButtonTap
            .map { Reactor.Action.navigationLeftButtonTap }
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
