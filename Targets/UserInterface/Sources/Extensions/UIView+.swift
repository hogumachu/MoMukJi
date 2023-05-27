//
//  UIView+.swift
//  UserInterface
//
//  Created by 홍성준 on 2023/05/18.
//

import UIKit
import SnapKit

extension UIView {
    
    public var safeArea: ConstraintBasicAttributesDSL {
        return self.safeAreaLayoutGuide.snp
    }
    
    public func maskRoundedRect(cornerRadius: CGFloat, corners: UIRectCorner) {
        let roundedRect = self.bounds
        let cornerRadii = CGSize(width: cornerRadius, height: cornerRadius)
        let path = UIBezierPath(
            roundedRect: roundedRect,
            byRoundingCorners: corners,
            cornerRadii: cornerRadii
        )
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    public func applyShadow(color: UIColor, opacity: Float, offset: CGSize, blur: CGFloat, spread: CGFloat = 0, cornerRadius: CGFloat = 0) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = blur
        self.clipsToBounds = false
        
        if spread == 0 {
            self.layer.shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            self.layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        }
    }
    
    public func setGradientBackground(
        startColor: UIColor,
        endColor: UIColor,
        startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0),
        endPoint: CGPoint = CGPoint(x: 1.0, y: 1.0)
    ) {
        guard (layer.sublayers?[0] as? CAGradientLayer) == nil else { return }
        if bounds == .init() { layoutIfNeeded() }
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

