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
    case foodCreate(Domain.Category, Mealtime)
    case foodTime(Domain.Category)
    case foodComplete(Food)
    case categoryList
    case categoryCreate
    case statistics
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
                foodUseCase: injector.resovle(FoodUseCase.self),
                timeHelper: MealtimeHelper()
            )
            let reactor = HomeReactor(dependency: dependency)
            let viewController = HomeViewController(reactor: reactor)
            return viewController
            
        case .foodCreate(let category, let mealtime):
            let dependency = FoodCreateReactor.Dependency(
                coordinator: coordinator,
                categoryUseCase: injector.resovle(CategoryUseCase.self),
                foodUseCase: injector.resovle(FoodUseCase.self),
                category: category,
                mealtime: mealtime
            )
            let reactor = FoodCreateReactor(dependency: dependency)
            let viewController = FoodCreateViewController(reactor: reactor)
            return viewController
            
        case .foodTime(let category):
            let dependency = FoodTimeReactor.Dependency(
                coordinator: coordinator,
                category: category,
                mealtimeHelper: MealtimeHelper()
            )
            let reactor = FoodTimeReactor(dependency: dependency)
            let viewController = FoodTimeViewController(reactor: reactor)
            return viewController
            
        case .foodComplete(let food):
            let dependency = FoodCompleteReactor.Dependency(
                coordinator: coordinator,
                food: food
            )
            let reactor = FoodCompleteReactor(dependency: dependency)
            let viewController = FoodCompleteViewController(reactor: reactor)
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
            
        case .statistics:
            let dependency = StatisticsReactor.Dependency(
                coordinator: coordinator,
                categoryUseCase: injector.resovle(CategoryUseCase.self),
                foodUseCase: injector.resovle(FoodUseCase.self)
            )
            let reactor = StatisticsReactor(dependency: dependency)
            let viewController = StatisticsViewController(reactor: reactor)
            return viewController
        }
    }
    
}
