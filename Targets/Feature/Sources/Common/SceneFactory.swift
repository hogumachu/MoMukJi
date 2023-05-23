//
//  SceneFactory.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/18.
//

import Core
import Domain
import Service
import UIKit
import RealmSwift

public enum Scene {
    case intro
    case home
    case foodCreate(Domain.Category)
    case categoryList
    case categoryCreate
}

public protocol SceneFactory {
    func create(scene: Scene) -> UIViewController
}

public final class SceneFactoryImpl: SceneFactory {
    
    private let injector: DependencyInjector
    
    public init(injector: DependencyInjector) {
        self.injector = injector
    }
    
    public func create(scene: Scene) -> UIViewController {
        let coordinator = injector.resovle(AppCoordinator.self)
        
        switch scene {
        case .intro:
            let dependency = IntroReactor.Depedency(coordinator: coordinator)
            let reactor = IntroReactor(dependency: dependency)
            let viewController = IntroViewController(reactor: reactor)
            return viewController
            
        case .home:
            let dependency = HomeReactor.Dependency(
                coordinator: coordinator,
                foodUseCase: injector.resovle(FoodUseCase.self)
            )
            let reactor = HomeReactor(dependency: dependency)
            let viewController = HomeViewController(reactor: reactor)
            return viewController
            
        case .foodCreate(let category):
            let dependency = FoodCreateReactor.Dependency(
                coordinator: coordinator,
                foodUseCase: injector.resovle(FoodUseCase.self),
                keywordUseCase: injector.resovle(KeywordUseCase.self),
                category: category
            )
            let reactor = FoodCreateReactor(dependency: dependency)
            let viewController = FoodCreateViewController(reactor: reactor)
            return viewController
            
        case .categoryList:
            let dependency = CategoryListReactor.Dependency(
                coordinator: coordinator,
                categoryUseCase: injector.resovle(CategoryUseCase.self)
            )
            let reactor = CategoryListReactor(dependency: dependency)
            let viewController = CategoryListViewController(reactor: reactor)
            return viewController
            
        case .categoryCreate:
            let dependency = CategoryCreateReactor.Dependency(
                coordinator: coordinator,
                categoryUseCase: injector.resovle(CategoryUseCase.self)
            )
            let reactor = CategoryCreateReactor(dependency: dependency)
            let viewController = CategoryCreateViewController(reactor: reactor)
            return viewController
        }
    }
    
}
