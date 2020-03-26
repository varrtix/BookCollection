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
import AVFoundation
import Alamofire
//import ESPullToRefresh
import SnapKit

class BCScanViewController: BCViewController {
  // View variables
  lazy fileprivate var scanView = BCScanView(
    self.view.frame,
    rect: BCScanView.Constraint.size,
    vertical: BCScanView.Constraint.verticalOffset
  )
  
  lazy fileprivate var _isMarked = false
  
  // controller variables
  lazy fileprivate var sessionIsCommitted = false
  
  fileprivate let captureSession = AVCaptureSession()
  
  fileprivate var state = State.stop {
    willSet {
      switch newValue {
        case .ready(let isbn):
          cleanup()
          BCBookInfoService.search(with: isbn) {
            BCDBResult.handle($0, success: { value in
              if value == nil {
                self._isMarked = false
                self.fetchBook(with: isbn)
              } else {
                self._isMarked = true
                self.state = .success(value!)
              }
            }) { V2RXError.printError($0) }
          }
        case .loading(let url):
          DispatchQueue.main.async {
            self.present(self.alertController(.waiting(url)), animated: true)
        }
        case .success(let book):
          DispatchQueue.main.async {
            self.dismiss {
              self.present(self.alertController(.success(book)), animated: true)
            }
        }
        case .failure(let error):
          DispatchQueue.main.async {
            self.dismiss {
              self.present(self.alertController(.failure(error)), animated: true)
            }
        }
        case .stop: break
      }
    }
  }
}

// MARK: - View lifecycle
extension BCScanViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = BCColor.BarTint.gray
    
    // configure components of view
    configureNavigationBar()
    configureScanView()
    configureTip()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    #if targetEnvironment(simulator)
    if !scanView.isAnimating { scanView.startAnimating() }
    #endif
    
    launch()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    #if targetEnvironment(simulator)
    state = .ready("9787115352118")
    #endif
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(launch),
      name: UIApplication.willEnterForegroundNotification,
      object: nil
    )
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    NotificationCenter.default.removeObserver(
      self,
      name: UIApplication.willEnterForegroundNotification,
      object: nil
    )
    
    cleanup()
    
    super.viewDidDisappear(animated)
  }
}

// MARK: - Launch actions
extension BCScanViewController {
  @objc func launch() {
    state = .stop
    // STEP 1: camera authorization
    // STEP 2: if allow camera session, else cleanup and dismiss
    guard cameraAuthorization() else {
      present(alertController(.authorize), animated: true)
      return
    }
    if sessionIsCommitted {
      startup()
      return
    }
    do {
      try configureCamera()
    } catch CameraError.invalidDevice {
      print("Invalid device")
    } catch CameraError.inputCaptureError {
      print("Input capture error")
    } catch {
      print("Unexpected error: \(error)")
    }
  }
  
  fileprivate func startup() {
    if !captureSession.isRunning { captureSession.startRunning() }
    if !scanView.isAnimating { scanView.startAnimating() }
  }
  
  fileprivate func cleanup() {
    if captureSession.isRunning { captureSession.stopRunning() }
    if scanView.isAnimating { scanView.stopAnimating() }
  }
}

// MARK: - Navigation settings
extension BCScanViewController {
  fileprivate func configureNavigationBar() {
    navigationBarBackgroundImage = UIImage()
    
    // The fucking items ARE NOT INCLUDED in property navigationController of itself.
    navigationItem.rightBarButtonItem = generateBarButton(
      "Scan/light-off",
      and: "Scan/light-on",
      action: #selector(light(_:)))
    
    guard #available(iOS 13.0, *) else {
      navigationItem.leftBarButtonItem = generateBarButton(
        "Scan/back-button",
        action: #selector(dismiss(_:)))
      return
    }
  }
  
  // loadButton
  fileprivate func generateBarButton(
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
  
  // BarButton Actions
  @objc fileprivate func dismiss(_ sender: UIButton? = nil) {
    navigationController?.dismiss(animated: true)
  }
  
  @objc fileprivate func light(_ sender: UIButton) {
    sender.isSelected.toggle()
    // TODO: Turn on and off the light.
  }
}

// MARK: - Visual modules
extension BCScanViewController {
  
  fileprivate enum CameraError: Error {
    case invalidDevice
    case inputCaptureError
  }
  
  fileprivate func configureCamera() throws {
    captureSession.beginConfiguration()
    
    guard let captureDevice = AVCaptureDevice.default(for: .video)
      else { throw CameraError.invalidDevice }
    
    do {
      guard let captureInput = try? AVCaptureDeviceInput(device: captureDevice)
        else { throw CameraError.inputCaptureError }
      
      if captureSession.canAddInput(captureInput) { captureSession.addInput(captureInput) }
      
    } catch let error as NSError {
      print("Input error: \(error)")
    }
    
    let captureOutput = AVCaptureMetadataOutput()
    captureOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
    
    if captureSession.canAddOutput(captureOutput) {
      captureSession.addOutput(captureOutput)
      // Filter types must be that after addoutput
      captureOutput.metadataObjectTypes = [.ean13]
    }
    
    // Add preview scene
    let layer = AVCaptureVideoPreviewLayer(session: captureSession)
    layer.frame = view.layer.bounds
    // IMPORTANT: addsublayer will replace the layer of scanView
    // but isnertsublayer at index 0 will replace parent's layer.
    view.layer.insertSublayer(layer, at: 0)
    
    captureSession.commitConfiguration()
    sessionIsCommitted = true
    startup()
  }
  
  fileprivate func configureScanView() {
    scanView.backgroundColor = .clear
    scanView.autoresizingMask = [.flexibleWidth, .flexibleHeight,]
    
    view.addSubview(scanView)
  }
  
  fileprivate func configureTip() {
    
  }
}

// MARK: - Alert modules
extension BCScanViewController {
  fileprivate enum Alert {
    case authorize
    case waiting(URL)
    case success(BCBook)
    case failure(AFError)
  }
  
  fileprivate func alertController(_ type: Alert) -> UIAlertController {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    alert.view.tintColor = .black
    
    switch type {
      case .authorize:
        alert.title = "Something wrong"
        alert.message = "This App need the permission to use iPhone's camera."
        let settingAction = UIAlertAction(title: "Setting", style: .default) { _ in
          guard let url = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(url) else { return }
          UIApplication.shared.open(url)
        }
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addActions([settingAction, cancelAction])
      
      case .waiting(let url):
        alert.title = "Loading"
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
          self.cancelRequest(for: url)
          self.launch()
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
          controller.isMarked = self._isMarked
          self.present(controller, animated: true)
        }
        alert.addAction(detailAction)
        alert.message = """
        \(book.title ?? "No title")
        \(book.isbn13 ?? "No ISBN13")
        \(book.authors?.first ?? "No author")
        """

        if _isMarked { break }

        let nextAction = UIAlertAction(title: "Mark and Continue", style: .cancel) { _ in
          self.launch()
        }
        alert.addAction(nextAction)
      
      case .failure(let error):
        alert.title = "Something wrong"
        alert.message = "Error: " + String(describing: error.errorDescription)
        let action = UIAlertAction(title: "OK", style: .cancel) { _ in
          self.launch()
        }
        alert.addAction(action)
    }
    
    return alert
  }
  
  fileprivate func dismiss(completion: (() -> Void)? = nil) {
    guard navigationController?.presentedViewController
      is UIAlertController else { return }
    navigationController?.presentedViewController?.view.layer.removeAllAnimations()
    navigationController?.dismiss(animated: true, completion: completion)
  }
}

// MARK: - ISBN identification
extension BCScanViewController: AVCaptureMetadataOutputObjectsDelegate {
  fileprivate enum State {
    case ready(String)
    case loading(URL)
    case success(BCBook)
    case failure(AFError)
    case stop
  }
  
  func metadataOutput(
    _ output: AVCaptureMetadataOutput,
    didOutput metadataObjects: [AVMetadataObject],
    from connection: AVCaptureConnection) {
    
    guard
      let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
      let ISBN = object.stringValue
      else { return }
    
    state = .ready(ISBN)
  }
  
  func fetchBook(with ISBN: String) {
    guard let url = URL(string: "https://douban.uieee.com/v2/book/isbn/\(ISBN)")
      else { return }
    
    state = .loading(url)
    
    AF.request(url)
      .validate()
      .responseDecodable(of: BCBook.self) { response in
        // TODO: Throws detail
        guard case let .failure(error) = response.result else {
          guard case let .success(book) = response.result else {
            print("Response success, but it has an unexpected error!")
            return
          }
          self.state = .success(book)
          return
        }
        self.state = .failure(error)
    }
  }
  
  fileprivate func cancelRequest(for url: URL?) {
    Alamofire.Session.default.session.getAllTasks {
      $0.forEach { task in
        guard
          let url = url,
          let taskURL = task.currentRequest?.url
          else { return }
        if taskURL == url { task.cancel() }
      }
    }
  }
}

// MARK: - Device authorization
extension BCScanViewController {
  func cameraAuthorization() -> Bool {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
      case .restricted: fallthrough
      case .denied: return false
      default: break
    }
    return true
  }
}
