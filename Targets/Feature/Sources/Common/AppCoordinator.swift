//
//  AppCoordinator.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/18.
//

import Core
import UserInterface
import UIKit

public enum TransitionStyle {
    case modal
    case push
}

public enum CloseStyle {
    case pop
    case dismiss
}

public protocol AppCoordinator {
    func start(root: Scene)
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool, completion: (() -> Void)?)
    func close(using style: CloseStyle, animated: Bool, completion: (() -> Void)?)
}

public final class AppCoordinatorImpl: AppCoordinator {
    
    private var currentNavigationController: UINavigationController?
    private let factory: SceneFactory
    
    public init(factory: SceneFactory) {
        self.factory = factory
    }
    
    public func start(root: Scene) {
        let rootViewController = factory.create(scene: root)
        self.currentNavigationController = rootViewController.navigationController
        UIApplication.keyWindow?.rootViewController = rootViewController
    }
    
    public func transition(to scene: Scene, using style: TransitionStyle, animated: Bool, completion: (() -> Void)?) {
        guard let topNavigationController = UIViewController.topViewController as? UINavigationController else {
            return
        }
        self.currentNavigationController = topNavigationController
        let viewController = factory.create(scene: scene)
        
        switch style {
        case .modal:
            topNavigationController.pushViewController(viewController, animated: animated)
            
        case .push:
            topNavigationController.present(viewController, animated: animated, completion: completion)
        }
    }
    
    public func close(using style: CloseStyle, animated: Bool, completion: (() -> Void)?) {
        
    }
    
}
