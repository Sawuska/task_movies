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
        let managedObjContext = AppDelegate().persistentContainer.viewContext
        let apiKey = "3fd5e68de77c9877441e0d99f37857e5"
        let language = getLanguage()

        let movieListFactory = MovieListFactory(
            apiKey: apiKey,
            language: language,
            managedObjContext: managedObjContext)
        let movieDetailsFactory = MovieDetailsFactory(
            apiKey: apiKey,
            language: language)
        let alertFactory = AlertFactory()

        let router = RouterImplementation(
            movieListFactory: movieListFactory,
            movieDetailsFactory: movieDetailsFactory,
            alertFactory: alertFactory,
            networkMonitor: NetworkMonitor.shared)

        window.rootViewController = router.getRootViewController()
        self.window = window
        window.makeKeyAndVisible()
    }

    private func getLanguage() -> String {
        Bundle.main.preferredLocalizations[0]
    }

}

