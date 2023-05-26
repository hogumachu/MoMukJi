//
//  ChartView.swift
//  UserInterface
//
//  Created by 홍성준 on 2023/05/26.
//

import UIKit
import SnapKit
import Then

public struct ChartViewModel {
    let charts: [(name: String, count: Int)]
    let description: String
    
    public init(charts: [(name: String, count: Int)], description: String) {
        self.charts = charts
        self.description = description
    }
}

public final class ChartView: UIView {
    
    private let stackViewHeight: CGFloat = 200
    private let stackView = UIStackView(frame: .zero)
    private let emptyGuidLabel = UILabel(frame: .zero)
    private let descriptionContainerView = UIView(frame: .zero)
    private let descriptionLabel = UILabel(frame: .zero)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupAttributes()
        setupEmptyState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(_ model: ChartViewModel) {
        emptyGuidLabel.isHidden = true
        descriptionLabel.text = model.description
        guard let maxCount = model.charts.map({ $0.count }).max() else {
            setupEmptyState()
            return
        }
        stackView.subviews.forEach { $0.removeFromSuperview() }
        model.charts.forEach { chart in
            let barView = ChartBarView(frame: .zero)
            barView.configure(name: chart.name, count: chart.count)
            stackView.addArrangedSubview(barView)
            barView.snp.makeConstraints { make in
                let ratio = CGFloat(chart.count) / CGFloat(maxCount)
                let minHeight: CGFloat = 40
                let height = ((stackViewHeight - minHeight) * ratio) + minHeight
                make.width.equalToSuperview().multipliedBy(0.8 / CGFloat(model.charts.count))
                make.height.equalTo(height)
            }
        }
    }
    
    private func setupEmptyState() {
        emptyGuidLabel.isHidden = false
        emptyGuidLabel.text = "등록된 정보가 없어요"
        descriptionLabel.text = "데이터가 부족해요.\n더 많은 데이터를 입력해주세요!"
    }
    
    private func setupLayout() {
        addSubview(descriptionContainerView)
        descriptionContainerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
        
        descriptionContainerView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(40)
            make.bottom.equalTo(descriptionContainerView.snp.top).offset(-20)
            make.height.equalTo(stackViewHeight)
        }
        
        addSubview(emptyGuidLabel)
        emptyGuidLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(stackView)
        }
    }
    
    private func setupAttributes() {
        stackView.do {
            $0.axis = .horizontal
            $0.alignment = .bottom
            $0.distribution = .equalSpacing
        }
        
        descriptionContainerView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
        }
        
        descriptionLabel.do {
            $0.textAlignment = .center
            $0.textColor = .monoblack
            $0.font = .captionSB
            $0.numberOfLines = 0
        }
        
        emptyGuidLabel.do {
            $0.textColor = .white
            $0.font = .headerSB
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
    }
    
}
