//
//  FoodCreateViewController.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/20.
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

final class FoodCreateViewController: BaseViewController<FoodCreateReactor> {
    
    typealias Section = RxTableViewSectionedReloadDataSource<FoodCreateSection>
    
    private var addButtonBottomConstraint: Constraint?
    
    private let navigationView = NavigationView(frame: .zero)
    private let tableView = EmptiableTableView(frame: .zero, style: .grouped)
    private let categoriesView = UIView(frame: .zero)
    private let textField = TextFiled(frame: .zero)
    private let addButton = ActionButton(frame: .zero)
    private lazy var dataSource = Section { section, tableView, indexPath, item in
        guard let cell = tableView.dequeueCell(FoodSearchResultTableViewCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        cell.configure(item)
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func setupLayout() {
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeArea.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
            addButtonBottomConstraint = make.bottom.equalTo(view.safeArea.bottom).constraint
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(addButton.snp.top)
        }
    }
    
    override func setupAttributes() {
        view.backgroundColor = .monoblack
        
        navigationView.do {
            $0.configure(.init(type: .back, title: nil))
        }
        
        tableView.do {
            $0.backgroundColor = .monoblack
            $0.register(FoodSearchResultTableViewCell.self)
            $0.configure(.init(title: "일치하는 결과가 없어요", description: "새로운 음식을 추가해주세요"))
            $0.separatorStyle = .singleLine
            $0.separatorColor = .pink1
            $0.separatorInset = .zero
        }
        
        textField.do {
            $0.placeholder = "어떤 음식을 드셨나요?"
            $0.layer.cornerRadius = 25
        }
        
        addButton.do {
            $0.style = .normal
            $0.setTitle("추가하기", for: .normal)
            $0.layer.cornerRadius = 24
        }
    }
    
    override func bind(reactor: FoodCreateReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
        bindETC(reactor: reactor)
    }
    
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardSize = notification.keyboardSize else { return }
        addButtonBottomConstraint?.update(offset: -keyboardSize.height)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private  func keyboardWillHide(_ notification: Notification) {
        addButtonBottomConstraint?.update(offset: 0)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
}

extension FoodCreateViewController {
    
    private func bindAction(reactor: Reactor) {
        rx.viewDidLoad
            .map { Reactor.Action.updateKeyword(nil) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        textField.rx.text
            .distinctUntilChanged()
            .map(Reactor.Action.updateKeyword)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected(dataSource: dataSource)
            .map(Reactor.Action.itemSeleted)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .map { Reactor.Action.addButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationView.rx.leftButtonTap
            .map { Reactor.Action.navigationLeftButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: Reactor) {
        reactor.state.map(\.sections)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map(\.keyword)
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.sections)
            .map { $0.isEmpty == false }
            .bind(to: tableView.rx.isEmptyViewHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.category)
            .bind(to: navigationView.rx.title)
            .disposed(by: disposeBag)
    }
    
    private func bindETC(reactor: Reactor) {
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
}

extension FoodCreateViewController: UITableViewDelegate {}
