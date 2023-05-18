//
//  CGFloat+Random.swift
//  Core
//
//  Created by 홍성준 on 2023/05/18.
//

import Foundation

extension CGFloat {
    
    public static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 4294967296)
    }
    
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
}
