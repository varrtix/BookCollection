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
  
  private lazy var scanView = BCScanView(frame: self.view.frame)
  
  private var store: BCBookStore?
  
  private let isbnCaptor = BCISBNCaptor()
  
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
  
  private lazy var backBarButton: UIBarButtonItem = {
    let button = UIButton(type: .custom)
    
    button.setImage(UIImage(named: "Scan/back-button"), for: .normal)
    button.tintColor = .white
    button.sizeToFit()
    
    
    button.addTarget(self, action: #selector(pop(_:)), for: .touchUpInside)
    
    return UIBarButtonItem(customView: button)
  }()
  
  private lazy var lightBarButton: UIBarButtonItem = {
    let button = UIButton(type: .custom)
    
    button.setImage(UIImage(named: "Scan/light-off"), for: .normal)
    button.setImage(UIImage(named: "Scan/light-on"), for: .selected)
    button.tintColor = .white
    button.sizeToFit()
    
    button.addTarget(self, action: #selector(light(_:)), for: .touchUpInside)
    
    return UIBarButtonItem(customView: button)
  }()
  
  deinit {
    NotificationCenter.default.removeObserver(
      self,
      name: UIApplication.willEnterForegroundNotification,
      object: nil
    )
  }
}

// MARK: - View controller life-cycle
extension BCScanViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(scan),
      name: UIApplication.willEnterForegroundNotification,
      object: nil
    )
    
    setup(view)
    
    setup(navigationItem)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    scan()
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
private extension BCScanViewController {
  
  func scan() {
    
    if let error = isbnCaptor.validate() {
      let setting = UIAlertAction(title: "Setting", tintColor: .black, style: .default) { _ in
        guard let url = URL(string: UIApplication.openSettingsURLString),
          UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
      }
      let cancel = UIAlertAction(title: "OK", tintColor: .red, style: .cancel) { _ in
        self.dismiss()
      }
      
      let alert = UIAlertController(
        title: "Permisson denied",
        message: error.localizedDescription,
        actions: [setting, cancel])
      
      present(alert, barrier: UIAlertController.self)
      
      return
    }
    
    isbnCaptor.setup()
    
    setupCaptureLayer()
    
    output()
  }
  
  func setupCaptureLayer() {
    captureLayer = isbnCaptor.layer
    
    captureLayer?.frame = view.layer.bounds
    
    if captureLayer != nil {
      view.layer.insertSublayer(captureLayer!, at: 0)
    }
  }
  
  func output() {
    scanView.startAnimating()
    
    isbnCaptor.output { [unowned self] result in
      self.scanView.stopAnimating()
      
      guard case let .success(isbn) = result else {
        self.dismiss()
        return
      }
      
      self.present(self.loadingAlert, barrier: UIAlertController.self)
      
      self.processing(isbn: isbn)
    }
  }
  
  func processing(isbn: String) {
    let alert = UIAlertController(title: "No title", message: "")
    
    store = BCBookStore(isbn: isbn)
    store?.getBook { [unowned self] result in
      if case let .success(value) = result, let book = value {
        alert.title = book.title ?? "Book Information"
        alert.message = """
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
          let next = UIAlertAction(title: "Mark and Continue", style: .default) { _ in
            self.bookShelf.append(book)
            self.output()
          }
          alert.addAction(next)
        }
        
        let cancel = UIAlertAction(title: "Cancel", tintColor: .red, style: .cancel) { _ in self.output() }
        alert.addAction(cancel)
        
      } else if case let .failure(error) = result {
        alert.title = "Something goes wrong"
        alert.message = error.localizedDescription
        let confirm = UIAlertAction(title: "OK", style: .cancel) { _ in
          self.dismiss()
        }
        alert.addAction(confirm)
      }
      self.present(alert, barrier: UIAlertController.self)
    }
  }
  
  func cleanup() {
    scanView.stopAnimating()
    
    captureLayer?.removeFromSuperlayer()
    captureLayer = nil
    
  }
  
  // MARK: BarButton actions
  func pop(_ sender: UIButton? = nil) { dismiss(animated: true) }
  
  func light(_ sender: UIButton) {
    sender.isSelected.toggle()
    isbnCaptor.toggleFlash()
  }
}

private extension BCScanViewController {
  func dismiss(completion: (() -> Void)? = nil) {
    presentedViewController?.view.layer.removeAllAnimations()
    dismiss(animated: true, completion: completion)
  }
  
  func present(
    _ viewControllerToPresent: UIViewController,
    barrier: UIViewController.Type? = nil,
    completion: (() -> Void)? = nil
  ) {
    if let type = barrier, self.presentedViewController?.isKind(of: type) ?? false {
      dismiss { self.present(viewControllerToPresent, animated: true, completion: completion) }
    } else {
      present(viewControllerToPresent, animated: true, completion: completion)
    }
  }
}
