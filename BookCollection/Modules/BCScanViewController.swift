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

class BCScanViewController: BCViewController {
  
  lazy fileprivate var scanView = BCScanView(
    self.view.frame,
    rect: BCScan.size,
    vertical: BCScan.verticalOffset
  )
  
  lazy fileprivate var captureSession = AVCaptureSession()
  
  lazy fileprivate var sessionIsCommitted = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemRed
    
    // configure components of view
    configureNavigationBar()
    configureScanView()
    configureTip()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(launch),
      name: UIApplication.willEnterForegroundNotification,
      object: nil
    )
    
    navigationBarHyalinization()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    launch()
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
  
  @objc func launch() {
    // STEP 1: camera authorization
    // STEP 2: if allow camera session, else cleanup and dismiss
    guard cameraAuthorization() else {
      presentAuthorizationAlert()
      return
    }
    if !sessionIsCommitted {
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
    startup()
  }
  
  func startup() {
    if !captureSession.isRunning { captureSession.startRunning() }
    if !scanView.isAnimating { scanView.startAnimating() }
  }
  
  func cleanup() {
    if captureSession.isRunning { captureSession.stopRunning() }
    if scanView.isAnimating { scanView.stopAnimating() }
  }
}

// MARK: - Navigation
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

// MARK: - View modules
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
    view.layer.addSublayer(layer)
    
    captureSession.commitConfiguration()
    sessionIsCommitted = true
  }
  
  fileprivate func configureScanView() {
    scanView.backgroundColor = .clear
    scanView.autoresizingMask = [.flexibleWidth, .flexibleHeight,]
    
    view.addSubview(scanView)
  }
  
  fileprivate func configureTip() {
    
  }
  
  fileprivate func presentAuthorizationAlert() {
    let alert = UIAlertController(
      title: "Something wrong",
      message: "This App need the permission to use iPhone's camera.",
      preferredStyle: .alert)
    
    let settingAction = UIAlertAction(title: "Setting", style: .default) { _ in
      guard let url = URL(string: UIApplication.openSettingsURLString),
        UIApplication.shared.canOpenURL(url) else { return }
      UIApplication.shared.open(url)
    }
    let cancelAction = UIAlertAction(title: "OK", style: .cancel)
    cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
    
    alert.addActions([settingAction, cancelAction])
    alert.view.tintColor = .black
    
    if navigationController?.presentedViewController is UIAlertController { return }
    
    navigationController?.present(alert, animated: true)
  }
}

// MARK: ISBN identification
extension BCScanViewController: AVCaptureMetadataOutputObjectsDelegate {
  
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
          self.present(alertController, animated: true)
          
          return
        }
    }
  }
}

// MARK - Device authorization
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
