//
//  SceneDelegate.swift
//  MoMukJi
//
//  Created by 홍성준 on 2023/05/18.
//

import Core
import Feature
import UIKit
import Swinject


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var coordiantor: AppCoordinator?
    private let injector: DependencyInjector = DependencyInjectorImpl(container: Container())
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // MARK: - Setup ViewController
        guard let scene = scene as? UIWindowScene else { return }
        setupDependencies()
        let window = UIWindow(windowScene: scene)
        self.window = window
        coordiantor?.start(root: .intro, from: window)
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
    
}

extension SceneDelegate {
    
    private func setupDependencies() {
        let appCoordinator = AppCoordinatorImpl(factory: SceneFactoryImpl(injector: injector))
        coordiantor = appCoordinator
        injector.assemble([])
        injector.register(AppCoordinator.self, appCoordinator)
    }
    
}
