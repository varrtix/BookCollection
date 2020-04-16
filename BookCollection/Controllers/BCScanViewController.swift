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

final class BCScanViewController: BCViewController {
  
  private lazy var scanView = BCScanView(
    self.view.frame,
    rect: BCScanView.Constraint.size,
    vertical: BCScanView.Constraint.verticalOffset
  )
  
  private var store: BCBookStore?
  
  private var isbnCaptor: BCISBNCaptor?
  
  private var captureLayer: CALayer?
  
  private let bookShelf = BCBookshelf.shared
  
  private lazy var loadingAlert: UIAlertController = {
    let alert = UIAlertController(title: "Loading", message: "...")
    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
      self.store?.cancelGetting()
    }
    alert.addAction(cancel)
    DispatchQueue.main.async {
      UIView.transition(
        with: alert.view,
        duration: 1.5,
        options: [.autoreverse, .repeat, .transitionCrossDissolve, .curveLinear],
        animations: {
          alert.message = "... ..."
      })
    }
    return alert
  }()
  
  @CustomBarButtonItem("Scan/back-button", target: self, action: #selector(pop(_:))) var backBarButton
  
  @CustomBarButtonItem("Scan/light-off", and: "Scan/light-on", target: self, action: #selector(light(_:))) var lightBarButton
}

// MARK: - View controller life-cycle
extension BCScanViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setup(view)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    startup()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(scan),
      name: UIApplication.willEnterForegroundNotification,
      object: nil
    )
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    cleanup()
  }
}

// MARK: - View configurations
private extension BCScanViewController {
  
  func setup(_ view: UIView) {
    view.backgroundColor = BCColor.BarTint.gray
    
    setup(navigationItem)
    
    view.addSubview(scanView)
  }
  
  func setup(_ item: UINavigationItem) {
    navigationBarBackgroundImage = UIImage()
    
    // The fucking items ARE NOT INCLUDED in property navigationController of itself.
    item.rightBarButtonItem = lightBarButton
    
    guard #available(iOS 13.0, *) else {
      item.leftBarButtonItem = backBarButton
      return
    }
  }
}

// MARK: - objc actions
@objc
fileprivate extension BCScanViewController {
  
  func startup() {
    
    isbnCaptor = BCISBNCaptor()
    
    captureLayer = isbnCaptor?.layer
    
    captureLayer?.frame = view.layer.bounds
    
    if captureLayer != nil {
      view.layer.insertSublayer(captureLayer!, at: 0)
    }
    
    scan()
  }
  
  func scan() {
    scanView.startAnimating()

    isbnCaptor?.output { [unowned self] result in
      self.scanView.stopAnimating()
      self.present(self.loadingAlert, barrier: UIAlertController.self)
      
      switch result {
        case let .success(isbn): self.processing(isbn: isbn)
        case let .failure(error):

          let setting = UIAlertAction(title: "Setting", tintColor: .black, style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url)
          }
          let cancel = UIAlertAction(title: "OK", tintColor: .red, style: .cancel)
          
          let alert = UIAlertController(
            title: "Permisson denied",
            message: error.localizedDescription,
            actions: [setting, cancel])
          
          self.present(alert, barrier: UIAlertController.self)
      }
    }
  }
  
  func processing(isbn: String) {
    let alert = UIAlertController(title: "Book INFO", message: "")

    store = BCBookStore(isbn: isbn)
    store?.getBook { [unowned self] result in
      if case let .success(value) = result, let book = value {
        alert.message = """
        \(book.title ?? "No title")
        \(book.isbn13 ?? "No ISBN13")
        \(book.authors?.first ?? "No author")
        """
        
        let detail = UIAlertAction(title: "Detail", style: .default) { _ in
          let controller = BCInfoViewController(with: book)
          let navigation = BCNavigationController(rootViewController: controller)
          self.present(navigation)
        }
        alert.addAction(detail)
        
        if !book.isMarked {
          let next = UIAlertAction(title: "Mark and Continue", style: .default) { _ in self.bookShelf.append(book) }
          alert.addAction(next)
        }
        
      } else if case let .failure(error) = result {
        alert.title = "Something goes wrong"
        alert.message = error.localizedDescription
        let confirm = UIAlertAction(title: "OK", style: .cancel) { _ in
          self.dismiss()
        }
        alert.addAction(confirm)
      }
    }
    present(alert, barrier: UIAlertController.self)
  }
  
  func cleanup() {
    scanView.stopAnimating()
    isbnCaptor = nil
    
    captureLayer?.removeFromSuperlayer()
    captureLayer = nil
    
    NotificationCenter.default.removeObserver(
      self,
      name: UIApplication.willEnterForegroundNotification,
      object: nil
    )
  }
  
  // MARK: BarButton actions
  func pop(_ sender: UIButton? = nil) {
    // TODO: checking the function dismiss of uiviewcontroller or navigationcontroller
    navigationController?.dismiss(animated: true)
  }
  
  func light(_ sender: UIButton) {
    sender.isSelected.toggle()
    // MARK: TODO: Turn on and off the light.
  }
}

fileprivate extension BCScanViewController {
  func dismiss(completion: (() -> Void)? = nil) {
    navigationController?.presentingViewController?.view.layer.removeAllAnimations()
    navigationController?.dismiss(animated: true, completion: completion)
  }
  
  func present(
    _ viewControllerToPresent: UIViewController,
    barrier: UIViewController.Type? = nil,
    completion: (() -> Void)? = nil
  ) {
    if let type = barrier.self,
      type === navigationController?.presentingViewController.self {
      dismiss()
    }
    navigationController?.present(viewControllerToPresent, animated: true, completion: completion)
  }
}

// MARK: - Custom bar button wrapper
@propertyWrapper
fileprivate struct CustomBarButtonItem {
  
  private var button: UIButton
  
  init(_ imageNamed: String, and selectImageNamed: String? = nil, target: Any?, action: Selector) {
    button = UIButton(type: .custom)
    
    button.setImage(UIImage(named: imageNamed), for: .normal)
    button.tintColor = .white
    button.sizeToFit()
    
    if let name = selectImageNamed { button.setImage(UIImage(named: name), for: .selected) }
    
    button.addTarget(target, action: action, for: .touchUpInside)
  }
  
  var wrappedValue: UIBarButtonItem { UIBarButtonItem(customView: button) }
}
