//
//  SceneDelegate.swift
//  Task Movies
//
//  Created by Alexandra on 31.07.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        window.rootViewController = MovieListViewController(viewModel: MovieListViewModel())
        self.window = window
        window.makeKeyAndVisible()
    }


}

