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

extension BCScanViewController {
  
  enum AlertType {
    case authorize
    case waiting(String)
    case success(BCBook)
    case failure(Error)
  }
  
  func dismiss(completion: (() -> Void)? = nil) {
    guard navigationController?.presentedViewController is UIAlertController else {
      if completion != nil { completion!() }
      return
    }
    navigationController?.presentedViewController?.view.layer.removeAllAnimations()
    navigationController?.dismiss(animated: true, completion: completion)
  }
  
  func presentAlert(_ type: AlertType, completion: @escaping () -> Void) {
    dismiss {
      self.present(self.alertController(type, completion: completion), animated: true)
    }
  }
  
  func alertController(_ type: AlertType, completion: @escaping () -> Void) -> UIAlertController {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    alert.view.tintColor = .black
    
    switch type {
      case .authorize:
        alert.title = "Permission denied"
        alert.message = "This App need the permission to use iPhone's camera."
        
        let settingAction = UIAlertAction(title: "Setting", style: .default) { _ in
          guard
            let url = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(url) else { return }
          UIApplication.shared.open(url)
        }
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { _ in completion() }
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addActions([settingAction, cancelAction])
      
      case .waiting(let isbn):
        alert.title = "Loading"
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
          BCBook.cancelFetch(with: isbn)
          completion()
        }
        alert.message = "..."
        alert.addAction(cancelAction)
        DispatchQueue.main.async {
          UIView.transition(
            with: alert.view,
            duration: 1.5,
            options: [.autoreverse, .repeat, .transitionCrossDissolve, .curveLinear],
            animations: {
              alert.message = "... ..."
          })
      }
      
      case .success(let book):
        alert.title = "Book Information"
        alert.message = "Not found!"
        
        let detailAction = UIAlertAction(title: "Detail", style: .default) { _ in
          let controller = BCInfoViewController(with: book)
//          if book.type == .database { controller.isMarked = true }
          let navigation = BCNavigationController(rootViewController: controller)
          self.present(navigation, animated: true)
        }
        alert.addAction(detailAction)
        alert.message = """
        \(book.title ?? "No title")
        \(book.isbn13 ?? "No ISBN13")
        \(book.authors?.first ?? "No author")
        """
        
//        if book.type == .networking {
//          let nextAction = UIAlertAction(title: "Mark and Continue", style: .cancel) { _ in completion() }
//          alert.addAction(nextAction)
//      }
      
      case .failure(let error):
        alert.title = "Error message"
        alert.message = "Error: " + String(describing: error.localizedDescription)
        let action = UIAlertAction(title: "OK", style: .cancel) { _ in completion() }
        alert.addAction(action)
    }
    
    return alert
  }
}
