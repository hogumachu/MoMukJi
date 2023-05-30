//
//  NavigationView.swift
//  UserInterface
//
//  Created by 홍성준 on 2023/05/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

public enum NavigationViewType {
    
    case back
    case backWithRightButton(NavigationRightButtonType)
    case close
    case none
    
}

public enum NavigationRightButtonType {
    case heart
    case heartFill
    
    var image: UIImage? {
        switch self {
        case .heart: return UIImage(systemName: "heart")
        case .heartFill: return UIImage(systemName: "heart.fill")
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .heart: return .white
        case .heartFill: return .red
        }
    }
}

extension NavigationViewType {
    
    var leftImage: UIImage? {
        switch self {
        case .back: return UIImage(systemName: "chevron.backward")
        case .backWithRightButton: return UIImage(systemName: "chevron.backward")
        case .close: return UIImage(systemName: "xmark")
        case .none: return nil
        }
    }
    
    var rightImage: UIImage? {
        switch self {
        case .back: return nil
        case .backWithRightButton(let type): return type.image
        case .close: return nil
        case .none: return nil
        }
    }
    
    var leftImageTintColor: UIColor {
        return .white
    }
    
    var rightImageTintColor: UIColor {
        switch self {
        case .back: return .white
        case .backWithRightButton(let type): return type.tintColor
        case .close: return .white
        case .none: return .white
        }
    }
    
}

public struct NavigationViewModel {
    
    public let type: NavigationViewType
    public let title: String?
    public let font: UIFont?
    
    public init(type: NavigationViewType, title: String?, font: UIFont? = .bodySB) {
        self.type = type
        self.title = title
        self.font = font
    }
    
}

public final class NavigationView: UIView {
    
    private var navigationTintColor: UIColor?
    public private(set) var model: NavigationViewModel?
    fileprivate let titleLabel = UILabel(frame: .zero)
    fileprivate let leftButton = NavigationViewButton(frame: .zero)
    fileprivate let rightButton = NavigationViewButton(frame: .zero)
    private let separator = UIView(frame: .zero)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(_ model: NavigationViewModel) {
        self.model = model
        titleLabel.text = model.title
        titleLabel.font = model.font
        
        leftButton.setImage(model.type.leftImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        rightButton.setImage(model.type.rightImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        if let tintColor = navigationTintColor {
            leftButton.imageTintColor = tintColor
            rightButton.imageTintColor = tintColor
        } else {
            leftButton.imageTintColor = model.type.leftImageTintColor
            rightButton.imageTintColor = model.type.rightImageTintColor
        }
    }
    
    public func updateTintColor(_ color: UIColor?) {
        self.leftButton.imageTintColor = color ?? .black
        self.rightButton.imageTintColor = color ?? .black
        self.titleLabel.textColor = color
        self.navigationTintColor = color
    }
    
    public func showTitle(_ title: String) {
        self.titleLabel.text  = title
        guard self.titleLabel.textColor == .clear else { return }
        UIView.animate(withDuration: 0.2) {
            self.titleLabel.textColor = self.navigationTintColor ?? .black
        }
    }
    
    public func hideTitle() {
        guard self.titleLabel.textColor != .clear else { return }
        UIView.animate(withDuration: 0.2) {
            self.titleLabel.textColor = .clear
        }
    }
    
    public func showSeparator() {
        guard self.separator.alpha == 0 else { return }
        UIView.animate(withDuration: 0.1) {
            self.separator.alpha = 1.0
        }
    }
    
    public func hideSeparator() {
        guard self.separator.alpha == 1.0 else { return }
        UIView.animate(withDuration: 0.1) {
            self.separator.alpha = 0
        }
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(66)
        }
        
        addSubview(leftButton)
        leftButton.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(52)
        }
        
        addSubview(rightButton)
        rightButton.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalTo(52)
        }
        
        addSubview(separator)
        separator.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    private func setupAttributes() {
        backgroundColor = .clear
        
        titleLabel.do {
            $0.textColor = .white
            $0.font = .bodyR
            $0.textAlignment = .center
        }
        
        leftButton.do {
            $0.tintColor = .white
            $0.contentMode = .center
            $0.adjustsImageWhenHighlighted = true
        }
        
        rightButton.do {
            $0.tintColor = .white
            $0.contentMode = .center
            $0.adjustsImageWhenHighlighted = true
        }
        
        separator.do {
            $0.backgroundColor = .white.withAlphaComponent(0.05)
            $0.alpha = 0
        }
    }
    
}

public extension Reactive where Base: NavigationView {
    
    var title: Binder<String?> {
        return base.titleLabel.rx.text
    }
    
    var leftButtonTap: ControlEvent<Void> {
        let source = base.leftButton.rx.tap
        return ControlEvent(events: source)
    }
    
    var rightButtonTap: ControlEvent<Void> {
        let source = base.rightButton.rx.tap
        return ControlEvent(events: source)
    }
    
}
