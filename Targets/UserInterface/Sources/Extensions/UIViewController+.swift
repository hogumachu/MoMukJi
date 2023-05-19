//
//  UIViewController+.swift
//  UserInterface
//
//  Created by 홍성준 on 2023/05/19.
//

import UIKit

extension UIViewController {
    
    public static var keyWindowRootViewController: UIViewController? {
        return UIApplication.keyWindow?.rootViewController
    }
    
    public static var topViewController: UIViewController? {
        guard let rootViewController = UIViewController.keyWindowRootViewController else {
            return nil
        }
        
        var topViewController = rootViewController
        
        while let top = topViewController.presentedViewController {
            topViewController = top
        }
        return topViewController
    }
    
}
