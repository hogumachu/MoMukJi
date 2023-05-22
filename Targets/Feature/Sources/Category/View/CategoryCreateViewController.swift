//
//  CategoryCreateViewController.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/21.
//

import Core
import UserInterface
import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa

final class CategoryCreateViewController: BaseViewController<CategoryCreateReactor> {
    
    private var saveButtonBottomConstraint: Constraint?
    
    private let categoryContainerView = UIView(frame: .zero)
    private let categoryLabel = UILabel(frame: .zero)
    private let categoryTextField = UITextField(frame: .zero)
    private let changeButtonStackView = UIStackView(frame: .zero)
    private let backgroundColorChangeButton = ActionButton(frame: .zero)
    private let labelColorChangeButton = ActionButton(frame: .zero)
    private let saveButton = ActionButton(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        categoryTextField.becomeFirstResponder()
    }
    
    override func setupLayout() {
        view.addSubview(categoryContainerView)
        categoryContainerView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeArea.top).offset(20)
        }
        
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
            saveButtonBottomConstraint = make.bottom.equalTo(view.safeArea.bottom).constraint
        }
        
        view.addSubview(categoryTextField)
        categoryTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
            make.bottom.equalTo(saveButton.snp.top).offset(-10)
        }
        
        view.addSubview(changeButtonStackView)
        changeButtonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
            make.top.equalTo(categoryContainerView.snp.bottom).offset(10)
        }
        
        changeButtonStackView.addArrangedSubview(backgroundColorChangeButton)
        changeButtonStackView.addArrangedSubview(labelColorChangeButton)
        
        categoryContainerView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    override func setupAttributes() {
        view.backgroundColor = .white
        
        categoryContainerView.do {
            $0.layer.cornerRadius = 16
        }
        
        categoryLabel.do {
            $0.textAlignment = .center
            $0.text = "하단에 텍스트를 입력해주세요"
        }
        
        categoryTextField.do {
            $0.layer.borderColor = UIColor.black.cgColor
            $0.layer.borderWidth = 0.1
            $0.layer.cornerRadius = 16
        }
        
        changeButtonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 5
            $0.alignment = .fill
            $0.distribution = .fillEqually
        }
        
        backgroundColorChangeButton.do {
            $0.style = .smallSecondary
            $0.setTitle("배경색 변경하기", for: .normal)
        }
        
        labelColorChangeButton.do {
            $0.style = .small
            $0.setTitle("글자색 변경하기", for: .normal)
        }
        
        saveButton.do {
            $0.style = .normal
            $0.setTitle("저장하기", for: .normal)
        }
    }
    
    override func bind(reactor: CategoryCreateReactor) {
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
        saveButtonBottomConstraint?.update(offset: -keyboardSize.height)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private  func keyboardWillHide(_ notification: Notification) {
        saveButtonBottomConstraint?.update(offset: 0)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
}

extension CategoryCreateViewController {
    
    private func bindAction(reactor: Reactor) {
        backgroundColorChangeButton.rx.tap
            .map { Reactor.Action.backgroundColorChangeButtonTap }
            .withUnretained(self)
            .subscribe(onNext: { this, action in
                reactor.action.onNext(action)
                this.showColorPicker()
            })
            .disposed(by: disposeBag)
        
        labelColorChangeButton.rx.tap
            .map { Reactor.Action.labelColorChangeButton }
            .withUnretained(self)
            .subscribe(onNext: { this, action in
                reactor.action.onNext(action)
                this.showColorPicker()
            })
            .disposed(by: disposeBag)
        
        categoryTextField.rx.text
            .map(Reactor.Action.updateCategory)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: Reactor) {
        reactor.state.map(\.category)
            .distinctUntilChanged()
            .bind(to: categoryLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.backgroundHexColor)
            .compactMap { $0 }
            .map { UIColor(hex: $0) }
            .bind(to: categoryContainerView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.labelHexColor)
            .compactMap { $0 }
            .map { UIColor(hex: $0) }
            .bind(to: categoryLabel.rx.textColor)
            .disposed(by: disposeBag)
    }
    
    private func showColorPicker() {
        let pickerViewController = UIColorPickerViewController()
        pickerViewController.delegate = self
        present(pickerViewController, animated: true)
    }
    
}

extension CategoryCreateViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let hexString = viewController.selectedColor.hexString
        reactor?.action.onNext(.selectedHexColor(hexString))
    }
    
}
