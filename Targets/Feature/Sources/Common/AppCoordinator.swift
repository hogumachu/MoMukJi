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
    func start(root: Scene, from window: UIWindow)
}

public final class AppCoordinatorImpl: AppCoordinator {
    
    private let factory: SceneFactory
    
    public init(factory: SceneFactory) {
        self.factory = factory
    }
    
    public func start(root: Scene, from window: UIWindow) {
        let rootViewController = factory.create(scene: root)
        window.rootViewController = rootViewController
    }
    
}
