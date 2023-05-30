//
//  MealtimeFoldableView.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/29.
//

import Core
import Domain
import UserInterface
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

struct MealtimeFoldableViewModel {
    let title: String
    let subtitle: String
    let times: [String]
    let isFolded: Bool
}

final class MealtimeFoldableView: BaseView {
    
    let titleLabel = UILabel(frame: .zero)
    let subtitleLabel = UILabel(frame: .zero)
    let toggleButton = UIButton(frame: .zero)
    let contentStackView = UIStackView(frame: .zero)
    
    func configure(_ model: MealtimeFoldableViewModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        contentStackView.subviews.forEach { $0.removeFromSuperview() }
        let configuration = UIImage.SymbolConfiguration(font: .bodySB)
        let image = UIImage(systemName: model.isFolded ? "chevron.down" : "chevron.up")?.withConfiguration(configuration)
        toggleButton.setImage(image, for: .normal)
        toggleButton.isHidden = model.times.count == 0
        backgroundColor = model.times.count == 0 ? .monogray2 : .white
        if !model.isFolded {
            model.times.forEach { text in
                let label = UILabel(frame: .zero)
                label.text = text
                label.textAlignment = .center
                label.textColor = .pink2
                label.font = .captionR
                contentStackView.addArrangedSubview(label)
            }
        }
    }
    
    override func setupLayout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }
        
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(5)
            make.centerY.equalTo(titleLabel)
        }
        
        addSubview(toggleButton)
        toggleButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 40, height: 30))
        }
        
        addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    override func setupAttributes() {
        layer.cornerRadius = 16
        
        backgroundColor = .white
        titleLabel.do {
            $0.textColor = .monoblack
            $0.font = .bodyB
            $0.textAlignment = .left
        }
        
        subtitleLabel.do {
            $0.textColor = .monogray3
            $0.font = .captionSB
            $0.textAlignment = .left
        }
        
        toggleButton.do {
            $0.tintColor = .white
            $0.backgroundColor = .pink1
            $0.layer.cornerRadius = 8
        }
        
        contentStackView.do {
            $0.backgroundColor = .clear
            $0.spacing = 5
            $0.axis = .vertical
            $0.alignment = .leading
            $0.distribution = .equalSpacing
        }
    }
    
}

extension Reactive where Base: MealtimeFoldableView {
    
    var title: Binder<String?> {
        return base.titleLabel.rx.text
    }
    
    var foldableButtonTap: ControlEvent<Void> {
        let source = base.toggleButton.rx.tap
        return ControlEvent(events: source)
    }
    
    var model: Binder<MealtimeFoldableViewModel> {
        return Binder(base) { view, model in
            view.configure(model)
        }
    }
    
}
