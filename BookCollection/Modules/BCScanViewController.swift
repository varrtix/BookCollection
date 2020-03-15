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
  
  lazy fileprivate var scanView = BCScanView(
    self.view.frame,
    rect: BCScan.size,
    vertical: BCScan.verticalOffset
  )

  fileprivate var state = State.ready {
    willSet {
      switch newValue {
        case .ready: break
        case .loading: break
//        case .success(let book): break
//        case .failure(let error): break
        default: break
      }
    }
  }
  
  @BCAlertController(.response) fileprivate var stateAlert: UIAlertController
  
  @BCAlertController(.authorization) fileprivate var authorizationAlert: UIAlertController

//  fileprivate var authorizationAlert: BCAlertController {
    
//    let alert = UIAlertController(
//      title: "Something wrong",
//      message: "This App need the permission to use iPhone's camera.",
//      preferredStyle: .alert)
//
//    let settingAction = UIAlertAction(title: "Setting", style: .default) { _ in
//      guard let url = URL(string: UIApplication.openSettingsURLString),
//        UIApplication.shared.canOpenURL(url) else { return }
//      UIApplication.shared.open(url)
//    }
//    let cancelAction = UIAlertAction(title: "OK", style: .cancel)
//    cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
//
//    alert.addActions([settingAction, cancelAction])
//    alert.view.tintColor = .black
//
//    return alert
//  }
  
//  lazy fileprivate var responseAlert = UIAlertController(
//    title: nil,
//    message: nil,
//    preferredStyle: .alert
//  )
  
//  fileprivate var state = State.ready {
//    didSet {
//    }
//  }
  
  lazy fileprivate var captureSession = AVCaptureSession()
  
  lazy fileprivate var sessionIsCommitted = false
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
    
    navigationBarHyalinization()
    
    #if targetEnvironment(simulator)
    if !scanView.isAnimating { scanView.startAnimating() }
    #endif
    
    launch()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    #if targetEnvironment(simulator)
//    presentLoadingAlert()
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
    // STEP 1: camera authorization
    // STEP 2: if allow camera session, else cleanup and dismiss
    guard cameraAuthorization() else {
      present(alert: authorizationAlert)
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
  fileprivate func navigationBarHyalinization() {
    // Generate a translucent NavigationBar
    navigationController?.navigationBar.isTranslucent = true
    // Clear navigationBar's color and the shadow line of its bottom.
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
  }
  
  fileprivate func configureNavigationBar() {
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
    case authorization, response
  }
  
  @propertyWrapper
  fileprivate struct BCAlertController {
    private var alert: UIAlertController

    init(_ type: Alert) {
      alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
      alert.view.tintColor = .black
      
      guard type == .authorization else { return }
      
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
    }
    
    var wrappedValue: UIAlertController { alert }
  }
//  fileprivate enum Alert {
//
//    case authorization, response(State)
//
//    static var alertController: UIAlertController {
//      let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
//      alert.view.tintColor = .black
//
//      switch self {
//        case .authorization:
//          alert.title = "Something wrong"
//          alert.message = "This App need the permission to use iPhone's camera."
//          let settingAction = UIAlertAction(title: "Setting", style: .default) { _ in
//            guard let url = URL(string: UIApplication.openSettingsURLString),
//              UIApplication.shared.canOpenURL(url) else { return }
//            UIApplication.shared.open(url)
//          }
//          let cancelAction = UIAlertAction(title: "OK", style: .cancel)
//          cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
//
//          alert.addActions([settingAction, cancelAction])
//
////        case .response(let state):
////          UIView.animate(withDuration: 1.0) {
//      }
//
//      return alert
//    }
//  }
  //  fileprivate func getResponseAlert() -> UIAlertController {
  //    UIAlertController(title: "Loading", message: nil, preferredStyle: .alert)
  //  }
  
  //  fileprivate func presentLoadingAlert() {
  //    let alert = UIAlertController(title: "Loading", message: nil, preferredStyle: .alert)
  //    let action = UIAlertAction(title: "OK", style: .cancel)
  //    alert.addAction(action)
  //
  //    let indicator = UIActivityIndicatorView(style: .gray)
  //
  //    alert.view.addSubview(indicator)
  //
  //    indicator.snp.makeConstraints {
  //      $0.center.equalToSuperview()
  //      $0.top.equalToSuperview().inset(50)
  //    }
  //
  //    indicator.isUserInteractionEnabled = false
  //    indicator.startAnimating()
  //
  //    animatingPresent(alert)
  //  }

  fileprivate func present<T: UIAlertController>(alert controller: T) {
    if navigationController?.presentedViewController is T { return }
    navigationController?.animatingPresent(controller)
  }
}

// MARK: - ISBN identification
extension BCScanViewController: AVCaptureMetadataOutputObjectsDelegate {
  fileprivate enum State {
    case ready, loading, success(Book), failure(AFError)
  }
  
  func metadataOutput(
    _ output: AVCaptureMetadataOutput,
    didOutput metadataObjects: [AVMetadataObject],
    from connection: AVCaptureConnection) {
    
    guard
      let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
      let ISBN = object.stringValue
      else { return }
    
    // Mission completed
    cleanup()
    
    fetchBookWith(ISBN)
  }
  
  func fetchBookWith(_ ISBN: String) {
    AF.request("https://douban.uieee.com/v2/book/isbn/\(ISBN)")
      .validate()
      .responseDecodable(of: Book.self) { response in
        // TODO: Throws detail
        guard case .failure(_) = response.result else {
          guard case let .success(book) = response.result else {
            print("Response success, but it has an unexpected error!")
            return
          }
          let alertController = UIAlertController(
            title: "Message",
            message: "\(book.title)\n\(book.isbn13)\n\(book.author[0])",
            preferredStyle: .alert)
          let detail = UIAlertAction(title: "Detail", style: .default)
          alertController.addAction(detail)
          
          let next = UIAlertAction(title: "Mark and Continue", style: .default) { _ in
            self.launch()
          }
          alertController.addAction(next)
          self.animatingPresent(alertController)
          
          return
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
