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

//typealias ISBNCaptorCompletion = (String) -> Void
//typealias ISBNCaptorHandler = (Result<String, Error>) -> Void
//let ISBNCaptor = BCISBNCaptor.shared

final class BCISBNCaptor: NSObject {
//  static let shared = BCISBNCaptor()
  enum State {
    case start, scanning, stop
  }
  
  typealias ISBNResult = Result<String, Error>
  
  typealias ISBNCaptorHandler = (ISBNResult) -> Void
  
  private let videoSession = AVCaptureSession()
  
  //  private let group = DispatchGroup()
  
  //  private let result: ISBNResult
  //  private var videoAuthorization: AVAuthorizationStatus {
  //    AVCaptureDevice.authorizationStatus(for: .video)
  //  }
  
  //  private var isPermitted: Bool { videoAuthorization == .authorized }
  
  //  var isRunning: Bool { videoSession.isRunning }
  
  var layer: CALayer { AVCaptureVideoPreviewLayer(session: videoSession) }
  
  var isRunning: Bool { state == .start || state == .scanning || videoSession.isRunning }
  
  //  var handler: BCISBNHandler?
  private var completion: ISBNCaptorHandler?
  
  private var state = State.stop
  //  private var result: ISBNResult?
  //  private var error: Error?
  //  private var isCommitted: Bool = false
  
  //  init(_ handler: @escaping BCISBNHandler) {
  //    self.handler = handler
  //
  //    super.init()
  //  }
  //  @discardableResult
  //  init(_ completion: @escaping ISBNCaptorHandler) {
  //    self.completion = completion
  
  //    super.init()
  
  //    capture()
  //    launch()
  //  }
  //  private override init() {
  //    super.init()
  //
  //    launch()
  //  }
  
  private func launch() -> Error? {
    var error: Error?
    switch AVCaptureDevice.authorizationStatus(for: .video) {
      case .authorized: error = capture()
      case .notDetermined:
        AVCaptureDevice.requestAccess(for: .video) { granted in
          if granted {
            error = self.capture()
          } else {
            //            self.completion?(
            //              .failure(CaptureError.invalidAuthorization(.notDetermined))
            //            )
            error = CaptureError.invalidAuthorization(.notDetermined)
          }
      }
      case .denied, .restricted: error = CaptureError.invalidAuthorization(.denied)
      //      case .denied: self.completion?(
      //        .failure(CaptureError.invalidAuthorization(.denied))
      //      )
      //      case .restricted: self.error = CaptureError.invalidAuthorization(.restricted)
      //      case .restricted: self.completion?(
      //        .failure(CaptureError.invalidAuthorization(.restricted))
      //      )
      @unknown default: break
    }
    return error
  }
  //  deinit { stopRunning() }
  
  //  @discardableResult
  //  func startRunning() -> Self {
  //    if !isRunning && isPermitted && isCommitted { session.startRunning() }
  //    return self
  //  }
  
  //  func stopRunning() {
  //    if isRunning { videoSession.stopRunning() }
  //  }
  
  //  func capture() -> CALayer? {
  private func capture() -> Error? {
    //    if isCommitted || !isPermitted { return nil }
    //    session.beginConfiguration()
    //    if !isPermitted {
    ////      completion(.failure(CaptureError.invalidAuthorization(videoAuthorization)))
    //      AVCaptureDevice.requestAccess(for: .video) { granted in
    //        if granted {
    //          self.capture()
    //        } else {
    //          self.completion(.failure(CaptureError.invalidAuthorization(self.videoAuthorization)))
    //        }
    //      }
    //      return
    //    }
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
      //    } catch { completion?(.failure(error)) }
    } catch { return error }
    
    //    videoSession.startRunning()
    //      else { return nil }
    //
    //    guard let captureInput = try? AVCaptureDeviceInput(device: captureDevice)
    //      //      else { throw CameraError.inputCaptureError }
    //      else { return nil }
    //
    //    if session.canAddInput(captureInput) {
    //      session.addInput(captureInput)
    //    }
    //
    //    let captureOutput = AVCaptureMetadataOutput()
    //    captureOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
    //
    //    if session.canAddOutput(captureOutput) {
    //      session.addOutput(captureOutput)
    //      // Filter types must be that after addoutput
    //      captureOutput.metadataObjectTypes = [.ean13]
    //    }
    
    // Add preview scene
    //    let layer = AVCaptureVideoPreviewLayer(session: captureSession)
    //    layer.frame = view.layer.bounds
    // IMPORTANT: addsublayer will replace the layer of scanView
    // but isnertsublayer at index 0 will replace parent's layer.
    //    view.layer.insertSublayer(layer, at: 0)
    
    //    session.commitConfiguration()
    //    sessionIsCommitted = true
    //    isCommitted = true
    //    startup()
    //    return AVCaptureVideoPreviewLayer(session: session)
  }
  
  func output(_ completionHandler: @escaping ISBNCaptorHandler) {
    //    videoSession.startRunning()
    
    completion = completionHandler
    
    state = .start
    if let error = launch() {
      //      completion?(.failure(error))
      state = .stop
      completion?(.failure(error))
    } else {
      state = .scanning
      videoSession.startRunning()
    }
  }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension BCISBNCaptor: AVCaptureMetadataOutputObjectsDelegate {
  func metadataOutput(
    _ output: AVCaptureMetadataOutput,
    didOutput metadataObjects: [AVMetadataObject],
    from connection: AVCaptureConnection
  ) {
    videoSession.stopRunning()
    
    guard
      let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
      let isbn = object.stringValue
      else { return }
    
    //    BCBook.fetch(with: isbn) { book in
    //      self.handler(book)
    //    }
    //    stopRunning()
    //    if handler != nil { handler!(isbn) }
    state = .stop
    
    completion?(.success(isbn))
  }
}
