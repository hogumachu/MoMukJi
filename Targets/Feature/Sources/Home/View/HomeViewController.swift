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
        switch item {
        case .title(let title):
            guard let cell = collectionView.dequeueCell(TextOnlyCollectionViewCell.self, for: indexPath) else {
                return UICollectionViewCell()
            }
            cell.configure(
                text: title,
                inset: UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
            )
            return cell
            
        case .food(let model):
            guard let cell = collectionView.dequeueCell(HomeFoodCollectionViewCell.self, for: indexPath) else {
                return UICollectionViewCell()
            }
            cell.configure(model)
            return cell
            
        case .time(let model):
            guard let cell = collectionView.dequeueCell(HomeTimeCollectionViewCell.self, for: indexPath) else {
                return UICollectionViewCell()
            }
            cell.configure(model)
            return cell
        }
    }
    
    override func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeArea.bottom).offset(-10)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
            make.width.equalTo(120)
        }
    }
    
    override func setupAttributes() {
        view.backgroundColor = .monoblack
        
        collectionViewFlowLayout.do {
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 20
            $0.minimumInteritemSpacing = 10
        }
        
        collectionView.do {
            $0.backgroundColor = .monoblack
            $0.register(TextOnlyCollectionViewCell.self)
            $0.register(HomeFoodCollectionViewCell.self)
            $0.register(HomeTimeCollectionViewCell.self)
            $0.configure(.init(title: "추가된 음식이 없어요", description: "새로운 음식을 추가해주세요"))
            $0.showsVerticalScrollIndicator = false
        }
        
        addButton.do {
            $0.style = .normal
            $0.setTitle("추가하기", for: .normal)
            $0.layer.cornerRadius = 30
        }
    }
    
    override func bind(reactor: HomeReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
        bindETC(reactor: reactor)
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
    
    private func bindETC(reactor: Reactor) {
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
}

extension HomeViewController: Refreshable {
    
    func refresh() {
        reactor?.action.onNext(.refresh)
    }
    
}

// MARK: - Cell Layout
extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let inset: CGFloat = 40
        guard let sections = reactor?.currentState.sections,
              let section = sections[safe: indexPath.section],
              let item = section.items[safe: indexPath.row]
        else {
            return .zero
        }
        switch item {
        case .title:
            return .init(width: view.frame.width - inset, height: 90)
            
        case .food:
            return .init(width: view.frame.width - inset, height: 70)
            
        case .time:
            let width = ((view.frame.width - inset) / 2) - spacing
            return .init(width: width, height: width)
        }
    }

}
