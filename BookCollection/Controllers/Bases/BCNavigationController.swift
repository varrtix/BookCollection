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

class BCNavigationController: UINavigationController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //    setupBar()
    setup(navigationBar)
    
    setup(&modalPresentationStyle)
    
    setup(&modalTransitionStyle)
  }
  
  // MARK: - Navigation configurations
  private func setup(_ bar: UINavigationBar) {
    //    navigationBar.barTintColor = BCColor.BarTint.green
    //    navigationBar.tintColor = BCColor.BarTint.white
    //    navigationBar.titleTextAttributes = [
    //      NSAttributedString.Key.foregroundColor: BCColor.BarTint.white
    //    ]
    bar.barTintColor = BCColor.BarTint.green
    bar.tintColor = BCColor.BarTint.white
    bar.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: BCColor.BarTint.white
    ]
  }
  
  private func setup(_ style: inout UIModalPresentationStyle) {
    //    if #available(iOS 13.0, *) {
    //      modalPresentationStyle = .automatic
    //    } else {
    //      modalPresentationStyle = .fullScreen
    //    }
    if #available(iOS 13.0, *) {
      style = .automatic
    } else {
      style = .fullScreen
    }
    //    modalTransitionStyle = .coverVertical
  }
  
  private func setup(_ style: inout UIModalTransitionStyle) {
    style = .coverVertical
  }
  
  override func present(
    _ viewControllerToPresent: UIViewController,
    animated flag: Bool,
    completion: (() -> Void)? = nil) {
    guard viewControllerToPresent is BCViewController else { return }
    viewControllerToPresent.hidesBottomBarWhenPushed =
      (viewControllerToPresent as! BCViewController).shouldHideBottomBarWhenPushed
    
    super.present(viewControllerToPresent, animated: true, completion: completion)
  }
}
