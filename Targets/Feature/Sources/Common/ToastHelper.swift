//
//  ToastHelper.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/30.
//

import UserInterface
import Foundation

enum ToastHelper {
    
    static func showSuccess(message: String) {
        ToastManager.showToast(.init(message: message, type: .success))
    }
    
    static func showFail(message: String) {
        ToastManager.showToast(.init(message: message, type: .fail))
    }
    
}
