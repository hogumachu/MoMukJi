//
//  DomainAssembly.swift
//  Domain
//
//  Created by 홍성준 on 2023/05/21.
//

import Core
import Swinject

public struct DomainAssembly: Assembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        container.register(FoodUseCase.self) { resolver in
            let repository = resolver.resolve(FoodRepository.self)!
            return FoodUseCaseImpl(repository: repository)
        }
        
        container.register(KeywordUseCase.self) { resolver in
            let repository = resolver.resolve(KeywordRepository.self)!
            return KeywordUseCaseImpl(repository: repository)
        }
        
        container.register(CategoryUseCase.self) { resolver in
            let repository = resolver.resolve(CategoryRepository.self)!
            return CategoryUseCaseImpl(repository: repository)
        }
    }
    
}
