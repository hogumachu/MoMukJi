//
//  Notification+.swift
//  UserInterface
//
//  Created by 홍성준 on 2023/05/21.
//

import UIKit

extension Notification {
    
    public var keyboardSize: CGRect? {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }
    
}
