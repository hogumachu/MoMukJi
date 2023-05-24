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
    func refresh()
}

public final class AppCoordinatorImpl: AppCoordinator {
    
    private var currentNavigationController: UINavigationController?
    private let factory: SceneFactory
    
    public init(factory: SceneFactory) {
        self.factory = factory
    }
    
    public func start(root: Scene) {
        let rootViewController = factory.create(scene: root)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.interactivePopGestureRecognizer?.delegate = nil
        self.currentNavigationController = navigationController
        UIApplication.keyWindow?.rootViewController = navigationController
    }
    
    public func transition(to scene: Scene, using style: TransitionStyle, animated: Bool, completion: (() -> Void)?) {
        guard let topViewController = UIViewController.topViewController else { return }
        currentNavigationController = topViewController as? UINavigationController ?? topViewController.navigationController
        let viewController = factory.create(scene: scene)
        
        switch style {
        case .modal:
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.setNavigationBarHidden(true, animated: false)
            navigationController.interactivePopGestureRecognizer?.delegate = nil
            navigationController.modalPresentationStyle = .overFullScreen
            currentNavigationController = navigationController
            topViewController.present(navigationController, animated: animated, completion: completion)
            
        case .push:
            currentNavigationController?.pushViewController(viewController, animated: animated)
        }
    }
    
    public func close(using style: CloseStyle, animated: Bool, completion: (() -> Void)?) {
        switch style {
        case .pop:
            currentNavigationController?.popViewController(animated: animated)
            
        case .dismiss:
            currentNavigationController?.dismiss(animated: animated, completion: completion)
        }
    }
    
    public func refresh() {
        guard let topViewController = UIViewController.topViewController else { return }
        if let navigationController = topViewController as? UINavigationController {
            (navigationController.topViewController as? Refreshable)?.refresh()
        } else {
            (topViewController as? Refreshable)?.refresh()
        }
    }
    
}
