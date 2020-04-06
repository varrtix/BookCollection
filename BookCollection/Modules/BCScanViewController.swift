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
  
  lazy fileprivate var scanView = BCScanView(
    self.view.frame,
    rect: BCScanView.Constraint.size,
    vertical: BCScanView.Constraint.verticalOffset
  )
  
  fileprivate let isbnService = BCISBNCaptor()
  
  fileprivate enum State {
    case ready, startup, running, stopping, done
  }
  
  fileprivate var state = State.done {
    willSet {
      switch newValue {
        case .ready: configureViews()
        case .startup: startup()
        case .running: launch()
        case .stopping: cleanup()
        case .done: break
      }
    }
  }
  
  deinit { state = .done }
}

// MARK: - View controller life-cycle
extension BCScanViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    state = .ready
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    state = .startup
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    state = .running
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    state = .stopping
  }
}

// MARK: - View configurations
fileprivate extension BCScanViewController {
  
  func configureViews() {
    view.backgroundColor = BCColor.BarTint.gray
    
    configureNavigationBar()
    configureScanView()
    configureTip()
  }
  
  func configureNavigationBar() {
    navigationBarBackgroundImage = UIImage()
    
    // The fucking items ARE NOT INCLUDED in property navigationController of itself.
    navigationItem.rightBarButtonItem = getBarButton(
      "Scan/light-off",
      and: "Scan/light-on",
      action: #selector(light(_:)))
    
    guard #available(iOS 13.0, *) else {
      navigationItem.leftBarButtonItem = getBarButton(
        "Scan/back-button",
        action: #selector(dismiss(_:)))
      return
    }
  }
  
  func configureScanView() { view.addSubview(scanView) }
  
  func configureTip() {}
  
  // MARK: Bar button wrapper
  func getBarButton(
    _ imageNamed: String, and selectImageNamed: String? = nil,
    action: Selector) -> UIBarButtonItem {
    
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: imageNamed), for: .normal)
    button.tintColor = .white
    button.sizeToFit()
    
    if let name = selectImageNamed { button.setImage(UIImage(named: name), for: .selected) }
    
    button.addTarget(self, action: action, for: .touchUpInside)
    
    return UIBarButtonItem(customView: button)
  }
}

// MARK: - objc actions
@objc
fileprivate extension BCScanViewController {
  
  func startup() {
    #if targetEnvironment(simulator)
    scanView.startAnimating()
    #endif
    
    if isbnService.isPermitted {
      if let layer = isbnService.capture() {
        layer.frame = view.layer.bounds
        view.layer.insertSublayer(layer, at: 0)
        scanView.startAnimating()
      }
    } else {
      present(alertController(.authorize, completion: {
        self.dismiss(animated: true)
      }), animated: true)
    }
  }
  
  func launch() {
    // STEP 1: camera authorization
    // STEP 2: if allow camera session, else cleanup and dismiss
    isbnService.startRunning().handler = { [unowned self] isbn in
      self.present(self.alertController(.waiting(isbn), completion: {
        self.state = .running
      }), animated: true)
      
      self.isbnService.stopRunning()
      
      BCBookInfoService.search(with: isbn) { result in
        guard case let .failure(error) = result else {
          if case let .success(book) = result {
            self.presentAlert(.success(book)) { self.state = .running }
          }
          return
        }
        
        if (error as? V2RXError.DataAccessObjects) == .notFound {
          BCBook.fetch(with: isbn) { response in
            switch response {
              case .success(let book):
                self.presentAlert(.success(book)) {
                  BCBookInfoService.mark(book) { dbResult in
                    switch dbResult {
                      case .success(_): self.state = .running
                      case .failure(let error): V2RXError.printError(error)
                    }
                  }
              }
              case .failure(let afError):
                self.presentAlert(.failure(afError)) { self.state = .running }
            }
          }
        } else {
          self.presentAlert(.failure(error)) { self.state = .running }
        }
      }
    }
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(launch),
      name: UIApplication.willEnterForegroundNotification,
      object: nil
    )
  }
  
  func cleanup() {
    isbnService.stopRunning()
    scanView.stopAnimating()
    
    NotificationCenter.default.removeObserver(
      self,
      name: UIApplication.willEnterForegroundNotification,
      object: nil
    )
  }
  
  // MARK: BarButton actions
  func dismiss(_ sender: UIButton? = nil) {
    navigationController?.dismiss(animated: true)
  }
  
  func light(_ sender: UIButton) {
    sender.isSelected.toggle()
    // MARK: TODO: Turn on and off the light.
  }
}
