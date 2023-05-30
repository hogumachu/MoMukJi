//
//  FavoriteFoodButtonsView.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/30.
//

import Core
import Domain
import UserInterface
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa


final class FavoriteFoodButtonsView: BaseView {
    
    let titleLabel = UILabel(frame: .zero)
    let buttonStackView = UIStackView(frame: .zero)
    let likeButton = ActionButton(frame: .zero)
    let dislikeButton = ActionButton(frame: .zero)
    
    override func setupLayout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.height.equalTo(48)
            make.leading.trailing.bottom.equalToSuperview()
        }
        buttonStackView.addArrangedSubview(dislikeButton)
        buttonStackView.addArrangedSubview(likeButton)
    }
    
    override func setupAttributes() {
        layer.cornerRadius = 16
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.alignment = .fill
            $0.distribution = .fillEqually
        }
        
        titleLabel.do {
            $0.font = .headerSB
        }
        
        likeButton.do {
            $0.style = .normal
            $0.setTitle("좋아요", for: .normal)
            $0.layer.cornerRadius = 16
        }
        
        dislikeButton.do {
            $0.style = .secondary
            $0.setTitle("그냥 그래요", for: .normal)
            $0.layer.cornerRadius = 16
        }
    }
    
}

extension Reactive where Base: FavoriteFoodButtonsView {
    
    var title: Binder<String?> {
        return base.titleLabel.rx.text
    }
    
    var likeButtonTap: ControlEvent<Void> {
        let source = base.likeButton.rx.tap
        return ControlEvent(events: source)
    }
    
    var dislikeButtonTap: ControlEvent<Void> {
        let source = base.dislikeButton.rx.tap
        return ControlEvent(events: source)
    }
    
}
