//
//  ToastManager.swift
//  UserInterface
//
//  Created by 홍성준 on 2023/05/21.
//

import UIKit
import Then

public enum ToastManager {
    
    public static func showToast(_ model: ToastModel) {
        guard let keyWindow = UIApplication.keyWindow else { return }
        let height: CGFloat = 35
        let viewSize = keyWindow.bounds.size
        let topSafeArea = keyWindow.safeAreaInsets.top
        let toast = ToastView(frame: CGRect(x: 20, y: topSafeArea, width: viewSize.width - 40, height: height))
        toast.alpha = 0
        toast.configure(model)
        keyWindow.addSubview(toast)
        keyWindow.bringSubviewToFront(toast)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) {
            toast.alpha = 1
            toast.frame.origin = CGPoint(x: 20, y: topSafeArea + height)
            toast.play()
        } completion: { _ in
            ToastCenter.shared.addToast(toast)
        }
    }
    
    static func hideToast(_ toast: ToastView) {
        let toastOrigin = toast.frame.origin
        let topSafeArea = UIApplication.keyWindow?.safeAreaInsets.top ?? 0
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut) {
            toast.alpha = 0
            toast.frame.origin = CGPoint(x: toastOrigin.x, y: topSafeArea)
            toast.stop()
        } completion: { _ in
            toast.removeFromSuperview()
        }
    }
    
}
