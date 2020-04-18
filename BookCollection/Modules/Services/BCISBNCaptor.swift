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

import AVFoundation

enum CaptureError: Error {
  case invalidAuthorization(AVAuthorizationStatus)
  case invalidDevice
  case rejectInput
  case rejectOutput
  
  var localizedDescription: String {
    switch self {
      case .invalidAuthorization(let status):
        var report = "Authorization Error: "
        switch status {
          case .denied: report += "denied"
          case .notDetermined: report += "not determined"
          case .restricted: report += "restricted"
          default: break
        }
        return report
      case .invalidDevice:
        return "Invalid capture device"
      case .rejectInput:
        return "Capture input has been rejected"
      case .rejectOutput:
        return "Capture output has been rejected"
    }
  }
}

final class BCISBNCaptor: NSObject {
  
  typealias ISBNResult = Result<String, Error>
  
  typealias ISBNCaptorHandler = (ISBNResult) -> Void
  
  private let videoSession = AVCaptureSession()
  
  private var isPermitted: Bool = false
  
  private var isCommitted: Bool = false
  
  private var isAvailable: Bool { isPermitted && isCommitted }
  
  private var completion: ISBNCaptorHandler?
  
  var layer: CALayer? { isAvailable ? AVCaptureVideoPreviewLayer(session: videoSession) : nil }
  
  var isRunning: Bool { videoSession.isRunning }
  
  var error: Error? = nil
  
  deinit { stopRunning() }
  
  private func startRunning() {
    if !isRunning { videoSession.startRunning() }
  }
  
  private func stopRunning() {
    if isRunning { videoSession.stopRunning() }
  }
  
  private func _setup() -> Error? {
    videoSession.beginConfiguration()
    
    do {
      guard let captureDevice = AVCaptureDevice.default(for: .video)
        else { throw CaptureError.invalidDevice }
      
      let captureInput = try AVCaptureDeviceInput(device: captureDevice)
      
      if videoSession.canAddInput(captureInput) {
        videoSession.addInput(captureInput)
      } else { throw CaptureError.rejectInput }
      
      let captureOutput = AVCaptureMetadataOutput()
      captureOutput.setMetadataObjectsDelegate(self, queue: .main)
      
      if videoSession.canAddOutput(captureOutput) {
        videoSession.addOutput(captureOutput)
        captureOutput.metadataObjectTypes = [.ean13]
      } else { throw CaptureError.rejectOutput }
      
      videoSession.commitConfiguration()
      
      return nil
    } catch { return error }
  }
  
  func validate() -> CaptureError? {
    isPermitted = false
    var error: CaptureError? = nil
    switch AVCaptureDevice.authorizationStatus(for: .video) {
      case .authorized: isPermitted = true
      case .notDetermined:
        AVCaptureDevice.requestAccess(for: .video) { granted in
          if !granted { error = CaptureError.invalidAuthorization(.notDetermined) }
      }
      case .denied, .restricted: error = CaptureError.invalidAuthorization(.denied)
      @unknown default: fatalError()
    }
    return error
  }
  
  func setup() {
    if isCommitted || !isPermitted { return }
    
    if let error = _setup() {
      self.error = error
    } else {
      isCommitted = true
    }
  }
  
  func output(_ completionHandler: @escaping ISBNCaptorHandler) {
    completion = completionHandler
    if isAvailable {
      startRunning()
    } else if let error = error {
      completion?(.failure(error))
    }
  }
  
  func toggleFlash() {
    guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
    
    do {
      try device.lockForConfiguration()
      try device.setTorchModeOn(level: 0.2)
      device.torchMode = device.isTorchActive ? .off : .on
      device.unlockForConfiguration()
    } catch { return }
  }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension BCISBNCaptor: AVCaptureMetadataOutputObjectsDelegate {
  func metadataOutput(
    _ output: AVCaptureMetadataOutput,
    didOutput metadataObjects: [AVMetadataObject],
    from connection: AVCaptureConnection
  ) {
    stopRunning()
    guard
      let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
      let isbn = object.stringValue
      else { return }
    
    completion?(.success(isbn))
  }
}
