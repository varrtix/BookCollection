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
  
//  lazy fileprivate var bars: [ViewTuple] = [
//    ("Collections", BCListViewController()),
//    ("Me", BCAnalyticViewController()),
//  ]
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
//    launchDatabase()
    setupWindow()
    
    return true
  }
}

// MARK: - RootViewController setting
extension AppDelegate: UITabBarControllerDelegate {
  private func setupWindow() {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    window?.rootViewController = BCTabBarViewController()
  }
}
//
//  fileprivate func setupWindow() {
//    window = UIWindow(frame: UIScreen.main.bounds)
//
//    window?.makeKeyAndVisible()
//
//    window?.rootViewController = loadTabBarController()
//  }
  
//  fileprivate func loadTabBarController() -> UITabBarController {
//    let tabBarController = UITabBarController()
//
//    tabBarController.delegate = self
//
//    tabBarController.tabBar.itemPositioning = .centered
//
//    tabBarController.tabBar.unselectedItemTintColor = BCColor.BarTint.gray
//    tabBarController.tabBar.barTintColor = BCColor.BarTint.white
//    tabBarController.tabBar.tintColor = BCColor.BarTint.green
//
//    tabBarController.viewControllers = bars.map { bar in
//      bar.item.tabBarItem.title = bar.title
//      bar.item.tabBarItem.image = UIImage(
//        named: "Tabbar/\(bar.title)")
//
//      if bar.item is BCListViewController {
//        return BCNavigationController(rootViewController: bar.item)
//      }
//
//      return bar.item
//    }
//
//    return tabBarController
//  }
//}

// MARK: - TabBar Delegate
//extension AppDelegate {
//
//  func tabBarController(
//    _ tabBarController: UITabBarController,
//    shouldSelect viewController: UIViewController) -> Bool { true }
//}

// MARK: - Database
//extension AppDelegate {
//  func launchDatabase() {
//      let database = BCDatabaseOperation()
//      database.start()
//      #if DEBUG
//      // MARK: TODO: Write all logs to a log file
//      print("Database path: \(BCDatabase.fileURL)")
//      #endif
//  }
//}
