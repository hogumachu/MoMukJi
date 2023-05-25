//
//  TextFiled.swift
//  UserInterface
//
//  Created by 홍성준 on 2023/05/25.
//

import UIKit
import SnapKit
import Then

public final class TextFiled: UITextField {
    
    public override var placeholder: String? {
        didSet { updatePlaceholder() }
    }
    
    public override var font: UIFont? {
        didSet { updatePlaceholder() }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: frame.height))
        leftViewMode = .always
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: frame.height))
        rightViewMode = .always
    }
    
    private func setupAttributes() {
        backgroundColor = .monogray1
        textColor = .monoblack
        font = .bodyB
    }
    
    private func updatePlaceholder() {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                .foregroundColor: UIColor.monogray2,
                .font: font
            ].compactMapValues { $0 }
        )
    }
    
}
