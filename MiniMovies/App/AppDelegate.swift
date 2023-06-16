//
//  AppDelegate.swift
//  MiniMovies
//
//  Created by Ade on 6/13/23.
//

import UIKit
import netfox
import IQKeyboardManagerSwift
import Kingfisher

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        NFX.sharedInstance().start()
        NFX.sharedInstance().setGesture(.custom)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        imageCacheSetup()
        
        showSplashScreen()
        
        return true
    }
    
    private func showSplashScreen() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        
        let navController = UINavigationController()
        
        let homeRouter = HomeRouter.start()
        
        guard let homeVC = homeRouter.entry else { return }
        
        navController.pushViewController(homeVC, animated: true)
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    private func imageCacheSetup() {
        let imageCache = ImageCache.default
        imageCache.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024 // Adjust the memory cache size if needed
        imageCache.diskStorage.config.sizeLimit = 200 * 1024 * 1024 // Adjust the disk cache size if needed
        imageCache.cleanExpiredMemoryCache()
        
        let kingfisherManager = KingfisherManager.shared        
        kingfisherManager.downloader.downloadTimeout = 10 // Set the desired timeout interval if needed
        kingfisherManager.cache.memoryStorage.config.expiration = .days(7) // Set an appropriate cache expiration time
        kingfisherManager.cache.diskStorage.config.expiration = .days(30) // Set an appropriate cache expiration time
        kingfisherManager.cache.cleanExpiredMemoryCache() // Set an appropriate cache expiration time
    }

}

extension UIWindow {
    override open func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        // code you want to implement
    #if DEV || DEBUG
        if motion == .motionShake {
            guard let view = UIApplication.topViewController() else {
                return
            }
            showSimpleActionSheet(controller: view)
        }
    #endif
    }
    
    func showSimpleActionSheet(controller: UIViewController) {
        let alert = UIAlertController(title: "Developer Side", message: "Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Network Manager", style: .default, handler: { (_) in
            NFX.sharedInstance().show()
        }))

        controller.present(alert, animated: true, completion: {})
        
    }
}
