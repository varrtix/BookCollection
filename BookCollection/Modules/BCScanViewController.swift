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

class BCScanViewController: UIViewController {
  
  lazy var scanView = BCScanView(
    frame: self.view.frame,
    rectSize: CGSize(width: 230.0, height: 230.0), offsetY: -43.0)
  
  lazy var captureSession = AVCaptureSession()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .red
    
    loadNavigation()
    loadSubviews()
  }

  func cleanup() {
    captureSession.stopRunning()
    scanView.stopAnimation()
  }
}

// MARK: - Navigation
extension BCScanViewController {
  fileprivate func loadNavigation() {
    // Generate a translucent NavigationBar
    navigationController?.navigationBar.isTranslucent = true
    // Clear navigationBar's color and the shadow line of its bottom.
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    
    // The fucking items ARE NOT INCLUDED in property navigationController of itself.
    navigationItem.leftBarButtonItem = loadButton(
      "Scan/back-button", action: #selector(back))
    navigationItem.rightBarButtonItem = loadButton(
      "Scan/light-off", and: "Scan/light-on", action: #selector(light(_:)))
  }
  
  // loadButton
  fileprivate func loadButton(
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
  @objc fileprivate func back() {
    dismiss(animated: true) { self.cleanup() }
  }
  
  @objc fileprivate func light(_ sender: UIButton) {
    sender.isSelected.toggle()
    // TODO: Turn on and off the light.
  }
}

// MARK: - Subviews
extension BCScanViewController {
  
  fileprivate enum CameraError: Error {
    case invalidDevice
    case inputCaptureError
  }

  fileprivate func loadSubviews() {
    
    do {
      try loadCamera()
    } catch CameraError.invalidDevice {
      print("Invalid Device!")
    } catch CameraError.inputCaptureError {
      print("Input Capture Error!")
    } catch {
      print("Unexpected error: \(error).")
    }
    
    loadScanView()
    loadTip()
  }
  
  fileprivate func loadCamera() throws {
    
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
    captureSession.startRunning()
  }
  
  fileprivate func loadScanView() {
    scanView.backgroundColor = .clear
    scanView.autoresizingMask = [.flexibleWidth, .flexibleHeight,]
    
    scanView.startAnimation()
    
    view.addSubview(scanView)
  }
  
  fileprivate func loadTip() {
    
  }
}

// MARK: ISBN identification
extension BCScanViewController: AVCaptureMetadataOutputObjectsDelegate {
  
  func metadataOutput(
    _ output: AVCaptureMetadataOutput,
    didOutput metadataObjects: [AVMetadataObject],
    from connection: AVCaptureConnection) {
    
    guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject
      else { return }
    
    print("ISBN: \(object.stringValue ?? String())")
    // Mission completed
    cleanup()
  }
}
