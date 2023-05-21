//
//  ServiceAssembly.swift
//  Service
//
//  Created by 홍성준 on 2023/05/21.
//

import Core
import Domain
import Swinject
import RealmSwift

public struct ServiceAssembly: Assembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        container.register(FoodRepository.self) { resolver in
            return FoodRepositoryImpl(realm: try! Realm())
        }
        
        container.register(KeywordRepository.self) { resolver in
            return KeywordRepositoryImpl()
        }
    }
    
}
