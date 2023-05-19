//
//  SceneFactory.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/18.
//

import Core
import UIKit

public enum Scene {
    case intro
    case home
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
            let dependency = HomeReactor.Dependency(coordinator: coordinator)
            let reactor = HomeReactor(dependency: dependency)
            let viewController = HomeViewController(reactor: reactor)
            return viewController
        }
    }
    
}
