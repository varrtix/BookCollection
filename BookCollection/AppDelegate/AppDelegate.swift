/// Copyright (c) 2020 VARRTIX
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  fileprivate typealias BarTuple = (
    title: String,
    viewController: UIViewController
  )
  
  fileprivate var bars: [BarTuple] = [
    ("Collections", BCListViewController()),
    ("Scan", BCScanViewController()),
    ("Me", BCAnalyticViewController()),
  ]
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = .white
    window?.makeKeyAndVisible()
    
    let navigation = UINavigationController(rootViewController: loadTabBarController())
    
    window?.rootViewController = navigation
    
    return true
  }
  
}

// MARK: - Tool functions
extension AppDelegate: UITabBarControllerDelegate {
  
  fileprivate func loadTabBarController() -> UITabBarController {
    let tabBarController = UITabBarController()
    tabBarController.delegate = self
    
    tabBarController.tabBar.unselectedItemTintColor = .darkGray
    tabBarController.tabBar.barTintColor = UIColor(
      red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1)
    tabBarController.tabBar.tintColor = UIColor(
      red: 0, green: 157 / 255.0, blue: 130 / 255.0, alpha: 1)
    
    tabBarController.viewControllers = bars.map { bar in
      bar.viewController.tabBarItem.title = bar.title
      bar.viewController.tabBarItem.image = UIImage(
        named: "Tabbar/tabbar-\(bar.title)")
      return bar.viewController
    }
    tabBarController.tabBar.itemPositioning = .centered
    
    return tabBarController
  }
}

// MARK: - TabBar Delegate
extension AppDelegate {
  
  func tabBarController(
    _ tabBarController: UITabBarController,
    shouldSelect viewController: UIViewController) -> Bool {
    
    if viewController is BCScanViewController {
      let navigationController = UINavigationController(
        rootViewController: BCScanViewController())
      
      navigationController.modalTransitionStyle = .coverVertical
      navigationController.modalPresentationStyle = .fullScreen
      
      window?.rootViewController?.present(navigationController, animated: true)
    }
    
    return true
  }
}
