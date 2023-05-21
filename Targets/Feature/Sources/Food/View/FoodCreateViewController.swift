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
import RxSwift
import RxCocoa

final class FoodCreateViewController: BaseViewController<FoodCreateReactor> {
    
    private var textFieldBottomConstraint: Constraint?
    
    private let categoriesView = UIView(frame: .zero)
    private let textField = UITextField(frame: .zero)
    
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
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
            textFieldBottomConstraint = make.bottom.equalTo(view.safeArea.bottom).constraint
        }
    }
    
    override func setupAttributes() {
        view.backgroundColor = .white
        
        textField.do {
            $0.backgroundColor = .systemPink
        }
    }
    
    override func bind(reactor: FoodCreateReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
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
        textFieldBottomConstraint?.update(offset: -keyboardSize.height)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private  func keyboardWillHide(_ notification: Notification) {
        textFieldBottomConstraint?.update(offset: 0)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
}

extension FoodCreateViewController {
    
    private func bindAction(reactor: Reactor) {
        
    }
    
    private func bindState(reactor: Reactor) {
        
    }
    
}
