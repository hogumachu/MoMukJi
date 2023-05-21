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
    
    private let tableView = UITableView(frame: .zero)
    private let categoriesView = UIView(frame: .zero)
    private let textField = UITextField(frame: .zero)
    private let addButton = ActionButton(frame: .zero)
    private lazy var dataSource = Section { section, tableView, indexPath, item in
        guard let cell = tableView.dequeueCell(RecentSearchResultTableViewCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        cell.configure(item)
        return cell
    }
    
    
    override init(reactor: Reactor) {
        super.init(reactor: reactor)
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
            addButtonBottomConstraint = make.bottom.equalTo(view.safeArea.bottom).constraint
            
        }
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalTo(addButton.snp.top).offset(-10)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(textField.snp.top)
        }
    }
    
    override func setupAttributes() {
        view.backgroundColor = .white
        
        tableView.do {
            $0.register(RecentSearchResultTableViewCell.self)
        }
        
        textField.do {
            $0.backgroundColor = .systemPink
        }
        
        addButton.do {
            $0.style = .normal
            $0.setTitle("추가하기", for: .normal)
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
            .map { Reactor.Action.search(nil) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        textField.rx.text
            .distinctUntilChanged()
            .map(Reactor.Action.updateKeyword)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected(dataSource: dataSource)
            .map(Reactor.Action.search)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .map { Reactor.Action.search(nil) }
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
    }
    
    private func bindETC(reactor: Reactor) {
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
}

extension FoodCreateViewController: UITableViewDelegate {}
