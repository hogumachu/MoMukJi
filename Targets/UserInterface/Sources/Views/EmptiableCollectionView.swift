//
//  EmptiableCollectionView.swift
//  UserInterface
//
//  Created by 홍성준 on 2023/05/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

public struct EmptiableCollectionViewModel {
    
    let title: String
    let titleFont: UIFont
    let titleColor: UIColor
    let description: String
    let descriptionFont: UIFont
    let descriptionTexxtColor: UIColor
    
    public init(
        title: String,
        titleFont: UIFont = .systemFont(ofSize: 20, weight: .semibold),
        titleColor: UIColor = .black,
        description: String,
        descriptionFont: UIFont = .systemFont(ofSize: 17, weight: .regular),
        descriptionTexxtColor: UIColor = .gray
    ) {
        self.title = title
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.description = description
        self.descriptionFont = descriptionFont
        self.descriptionTexxtColor = descriptionTexxtColor
    }
    
}

public class EmptiableCollectionView: UICollectionView {
    
    public let emptyView = CenteredTextDescriptionView(frame: .zero)
    
    public override var backgroundColor: UIColor? {
        didSet {
            emptyView.backgroundColor = backgroundColor
        }
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupEmptyView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(_ viewModel: EmptiableCollectionViewModel) {
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

public extension Reactive where Base: EmptiableCollectionView {
    
    var isEmptyViewHidden: Binder<Bool> {
        return base.emptyView.rx.isHidden
    }
    
}
