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
  
  lazy fileprivate var bars: [BCTools.ViewTuple] = [
    ("Collections", BCListViewController()),
    ("Me", BCAnalyticViewController()),
  ]
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    loadWindow()
    
    return true
  }
}

// MARK: - RootViewController Setting
extension AppDelegate: UITabBarControllerDelegate {
  
  fileprivate func loadWindow() {
    window = UIWindow(frame: UIScreen.main.bounds)
    
    window?.backgroundColor = .white
    window?.makeKeyAndVisible()
    
    window?.rootViewController = loadTabBarController()
  }
  
  fileprivate func loadTabBarController() -> UITabBarController {
    let tabBarController = UITabBarController()
    
    tabBarController.delegate = self
    
    tabBarController.tabBar.itemPositioning = .centered
    tabBarController.tabBar.unselectedItemTintColor = .darkGray
    tabBarController.tabBar.barTintColor = UIColor(
      red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1)
    tabBarController.tabBar.tintColor = UIColor(
      red: 0, green: 157 / 255.0, blue: 130 / 255.0, alpha: 1)
    
    tabBarController.viewControllers = bars.map { bar in
      bar.item.tabBarItem.title = bar.title
      bar.item.tabBarItem.image = UIImage(
        named: "Tabbar/\(bar.title)")
      return bar.item
    }
    
    return tabBarController
  }
}

// MARK: - TabBar Delegate
extension AppDelegate {
  
  func tabBarController(
    _ tabBarController: UITabBarController,
    shouldSelect viewController: UIViewController) -> Bool { true }
}

// MARK: - Guff
struct BCTools {
  
  typealias ViewTuple = (title: String, item: UIViewController)
  
}
