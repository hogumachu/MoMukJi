//
//  ActionButton.swift
//  UserInterface
//
//  Created by 홍성준 on 2023/05/19.
//

import UIKit
import SnapKit
import Then

public enum ActionButtonStyle {
    
    // TODO: - Font, Color 변경
    
    case normal
    case secondary
    case small
    case smallSecondary
    case alert
    
    var defaultTextColor: UIColor? {
        switch self {
        case .normal:           return .white
        case .secondary:        return .systemBlue
        case .small:            return .white
        case .smallSecondary:   return .systemBlue
        case .alert:            return .white
        }
    }
    
    var disabledTextColor: UIColor? {
        return .systemGray
    }
    
    var defaultBackgroundColor: UIColor? {
        switch self {
        case .normal:           return .systemBlue
        case .secondary:        return .systemGray3
        case .small:            return .systemBlue
        case .smallSecondary:   return .systemGray3
        case .alert:            return .systemRed
        }
    }
    
    var highlightedBackgroundColor: UIColor? {
        switch self {
        case .normal:           return .systemBlue
        case .secondary:        return .systemGray4
        case .small:            return .systemBlue
        case .smallSecondary:   return .systemGray4
        case .alert:            return .systemRed
        }
    }
    
    var disabledBackgroundColor: UIColor? {
        return .systemGray3
    }
    
    var font: UIFont? {
        return .systemFont(ofSize: 17)
    }
    
    var disabledFont: UIFont? {
        return .systemFont(ofSize: 17)
    }
    
}

public final class ActionButton: UIButton {
    
    public var style: ActionButtonStyle = .normal {
        didSet {
            updateFont()
            updateTextColor()
            updateBackgroundColor()
        }
    }
    
    public override var isHighlighted: Bool {
        didSet {
            pressedView.isHidden = !isHighlighted
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? style.defaultBackgroundColor : style.disabledBackgroundColor
            updateFont()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupAttributes()
        setupPressedView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAttributes() {
        layer.borderColor = UIColor.black.withAlphaComponent(0.01).cgColor
        layer.borderWidth = 0.5
        clipsToBounds = true
        
        backgroundColor = self.style.defaultBackgroundColor
        setTitleColor(self.style.defaultTextColor, for: .normal)
        setTitleColor(self.style.disabledTextColor, for: .disabled)
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
    }
    
    private func setupPressedView() {
        addSubview(self.pressedView)
        pressedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pressedView.do {
            $0.backgroundColor = .white.withAlphaComponent(0.3)
            $0.isUserInteractionEnabled = false
            $0.isHidden = true
        }
    }
    
    private func updateFont() {
        titleLabel?.font = isEnabled ? style.font : style.disabledFont
    }
    
    private func updateTextColor() {
        setTitleColor(style.defaultTextColor, for: .normal)
        setTitleColor(style.disabledTextColor, for: .disabled)
    }
    
    private func updateBackgroundColor() {
        backgroundColor = style.defaultBackgroundColor
        if isHighlighted {
            pressedView.isHidden = !isHighlighted
        }
        
        if isEnabled == false {
            backgroundColor = style.disabledBackgroundColor
        }
    }
    
    private let pressedView = UIView(frame: .zero)
    
}
