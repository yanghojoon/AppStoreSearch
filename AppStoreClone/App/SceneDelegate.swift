import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        
        let appListViewController = AppListViewController()
        let navigationController = UINavigationController(rootViewController: appListViewController)
        
        window?.rootViewController = navigationController
        navigationController.view.backgroundColor = .systemBackground
    }
    
}

