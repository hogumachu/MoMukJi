//
//  Array+.swift
//  Core
//
//  Created by 홍성준 on 2023/05/18.
//

import Foundation

extension Array {
    
    public subscript (safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
    
}
