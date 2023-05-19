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
        guard let scene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: scene)
        self.window = window
        window.makeKeyAndVisible()
        setupDependencies()
        if UserDefaults.standard.bool(key: .isIntroDidShown) {
            coordiantor?.start(root: .home)
        } else {
            UserDefaults.standard.setValue(true, key: .isIntroDidShown)
            coordiantor?.start(root: .intro)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
    
}

extension SceneDelegate {
    
    private func setupDependencies() {
        let factory = SceneFactoryImpl(injector: injector)
        let appCoordinator = AppCoordinatorImpl(factory: factory)
        coordiantor = appCoordinator
        injector.assemble([])
        injector.register(AppCoordinator.self, appCoordinator)
    }
    
}
