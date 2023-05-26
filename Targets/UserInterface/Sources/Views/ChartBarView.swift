//
//  ChartBarView.swift
//  UserInterface
//
//  Created by 홍성준 on 2023/05/26.
//

import UIKit
import SnapKit
import Then

public final class ChartBarView: UIView {
    
    public let nameLabel = UILabel(frame: .zero)
    public let countLabel = UILabel(frame: .zero)
    public let barView = UIView(frame: .zero)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        barView.maskRoundedRect(cornerRadius: 8, corners: [.topLeft, .topRight])
    }
    
    public func configure(name: String, count: Int) {
        nameLabel.text = name
        countLabel.text = "\(count)회"
    }
    
    private func setupLayout() {
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        addSubview(barView)
        barView.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(nameLabel.snp.top).offset(-3)
        }
    }
    
    private func setupAttributes() {
        nameLabel.do {
            $0.font = .captionSB
            $0.textColor = .pink1
            $0.textAlignment = .center
        }
        
        countLabel.do {
            $0.font = .captionSB
            $0.textColor = .yellow1
            $0.textAlignment = .center
        }
        
        barView.do {
            $0.backgroundColor = .pink1
        }
    }
    
}
