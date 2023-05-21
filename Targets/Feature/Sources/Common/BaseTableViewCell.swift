//
//  BaseTableViewCell.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/21.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clear()
    }
    
    func clear() {}
    func setupLayout() {}
    func setupAttributes() {}
    
}
