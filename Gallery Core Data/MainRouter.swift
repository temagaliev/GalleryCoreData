//
//  MainRouter.swift


import UIKit
import MessageUI

final class MainRouter {
    
    static let shared: MainRouter = MainRouter()
    
    private init() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
    }
    
    private (set) var window: UIWindow
    private var rootViewController: UINavigationController?
    
    func showTmpMainScreen() {
        print("   ---   show main screen")
        let vc = MenuViewController(nibName: "MenuViewController", bundle: nil)
        
        self.rootViewController = UINavigationController(rootViewController: vc)
        self.window.rootViewController = self.rootViewController
    }
    
    
    func showPhotoViewScreen(vc: UIImagePickerController) {
        rootViewController?.pushViewController(vc, animated: true)
    }
    
    func closePhotoViewScreen() {
        rootViewController?.popViewController(animated: true)
    }

    
    private func pushToRoot(controller: UIViewController) {
        if let vc = rootViewController {
            if let topmostVC = vc.viewControllers.last, type(of: topmostVC) == type(of: controller) {
                vc.popViewController(animated: false)
                DispatchQueue.main.async {
                    vc.pushViewController(controller, animated: true)
                }
            } else {
                vc.pushViewController(controller, animated: true)
            }
        }
    }
}
