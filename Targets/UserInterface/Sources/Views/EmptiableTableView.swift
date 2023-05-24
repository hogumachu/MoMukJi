//
//  EmptiableTableView.swift
//  UserInterface
//
//  Created by 홍성준 on 2023/05/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

public struct EmptiableTableViewModel {
    
    let title: String
    let titleFont: UIFont
    let titleColor: UIColor?
    let description: String
    let descriptionFont: UIFont
    let descriptionTexxtColor: UIColor?
    
    public init(
        title: String,
        titleFont: UIFont = .headerSB,
        titleColor: UIColor = .white,
        description: String,
        descriptionFont: UIFont = .bodyR,
        descriptionTexxtColor: UIColor? = .monogray1
    ) {
        self.title = title
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.description = description
        self.descriptionFont = descriptionFont
        self.descriptionTexxtColor = descriptionTexxtColor
    }
    
}

public class EmptiableTableView: UITableView {
    
    public let emptyView = CenteredTextDescriptionView(frame: .zero)
    
    public override var backgroundColor: UIColor? {
        didSet {
            emptyView.backgroundColor = backgroundColor
        }
    }
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupEmptyView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(_ viewModel: EmptiableTableViewModel) {
        emptyView.textLabel.text = viewModel.title
        emptyView.textLabel.font = viewModel.titleFont
        emptyView.textLabel.textColor = viewModel.titleColor
        emptyView.descriptionLabel.text = viewModel.description
        emptyView.descriptionLabel.font = viewModel.descriptionFont
        emptyView.descriptionLabel.textColor = viewModel.descriptionTexxtColor
    }
    
    private func setupEmptyView() {
        addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}

public extension Reactive where Base: EmptiableTableView {
    
    var isEmptyViewHidden: Binder<Bool> {
        return base.emptyView.rx.isHidden
    }
    
}
