//
//  NavigationViewButton.swift
//  UserInterface
//
//  Created by 홍성준 on 2023/05/24.
//

import UIKit

public final class NavigationViewButton: UIButton {
    
    public var imageTintColor: UIColor = .gray {
        didSet {
            self.tintColor = self.imageTintColor
        }
    }
    
    public override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                self.tintColor = .gray
            } else {
                self.tintColor = self.imageTintColor
            }
        }
    }
    
}
