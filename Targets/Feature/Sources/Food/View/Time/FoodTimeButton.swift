//
//  FoodTimeButton.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/25.
//

import Core
import UserInterface
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

enum FoodTimeButtonModel: CaseIterable {
    
    case morning
    case lunch
    case dinner
    case midnightSnack
    
    var food: String {
        switch self {
        case .morning: return "아침"
        case .lunch: return "점심"
        case .dinner: return "저녁"
        case .midnightSnack: return "야식"
        }
    }
    
    var time: String {
        switch self {
        case .morning: return "05:00 ~ 10:00"
        case .lunch: return "10:00 ~ 16:00"
        case .dinner: return "16:00 ~ 22:00"
        case .midnightSnack: return "22:00 ~ 04:00"
        }
    }
    
    var textColor: UIColor? {
        switch self {
        case .morning: return .monoblack
        case .lunch: return .white
        case .dinner: return .white
        case .midnightSnack: return .monoblack
        }
    }
    
    var backgroundColor: UIColor? {
        switch self {
        case .morning: return .yellow1
        case .lunch: return .blue1
        case .dinner: return .blue3
        case .midnightSnack: return .pink1
        }
    }
}

final class FoodTimeButton: UIButton {
    
    var model: FoodTimeButtonModel?
    
    private let foodLabel = UILabel(frame: .zero)
    private let timeLabel = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: FoodTimeButtonModel) {
        self.model = model
        foodLabel.text = model.food
        foodLabel.textColor = model.textColor
        timeLabel.text = model.time
        timeLabel.textColor = model.textColor
        backgroundColor = model.backgroundColor
    }
    
    private func setupLayout() {
        addSubview(foodLabel)
        foodLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(foodLabel.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func setupAttributes() {
        foodLabel.do {
            $0.font = .headerSB
            $0.textAlignment = .center
        }
        
        timeLabel.do {
            $0.font = .captionR
            $0.textAlignment = .center
        }
    }
    
}

extension Reactive where Base: FoodTimeButton {
    
    var tapWithModel: ControlEvent<FoodTimeButtonModel?> {
        let source = base.rx.tap.map { base.model }
        return ControlEvent(events: source)
    }
    
}
