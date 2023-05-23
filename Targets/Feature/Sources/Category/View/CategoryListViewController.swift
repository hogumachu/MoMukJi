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
    
    private let addButton = ActionButton(frame: .zero)
    private let collectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    private lazy var dataSource = Section { section, collectionView, indexPath, item in
        guard let cell = collectionView.dequeueCell(CategoryListCollectionViewCell.self, for: indexPath) else {
            return UICollectionViewCell()
        }
        cell.configure(item)
        return cell
    }
    
    override func setupLayout() {
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeArea.bottom).offset(-10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(addButton.snp.top)
        }
    }
    
    override func setupAttributes() {
        view.backgroundColor = .white
        
        collectionViewFlowLayout.do {
            $0.itemSize = .init(width: (view.frame.width / 2) - 30, height: 60)
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 10
        }
        
        collectionView.do {
            $0.backgroundColor = .white
            $0.register(CategoryListCollectionViewCell.self)
        }
        
        addButton.do {
            $0.style = .normal
            $0.setTitle("카테고리 추가하기", for: .normal)
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
    }
    
    private func bindState(reactor: Reactor) {
        reactor.state.map(\.sections)
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
}
