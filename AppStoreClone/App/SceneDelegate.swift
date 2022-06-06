import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties
    var window: UIWindow?
    var coordinator: Coordinator?

    // MARK: - Methods
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        
        coordinator = FlowCoordinator(rootViewController: navigationController)
        coordinator?.start()
        
        navigationController.view.backgroundColor = .systemBackground
    }
    
}

