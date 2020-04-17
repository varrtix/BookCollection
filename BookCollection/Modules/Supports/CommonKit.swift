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

// MARK: - UIColor Extension
public extension UIColor {
  convenience init(R: Int, G: Int, B: Int, A: Float) {
    assert(0...255 ~= R, "Invalid red component")
    assert(0...255 ~= G, "Invalid green component")
    assert(0...255 ~= B, "Invalid blue component")
    assert(0.0...1.0 ~= A, "Invalid Alpha component")
    
    self.init(
      red: CGFloat(R) / 255.0,
      green: CGFloat(G) / 255.0,
      blue: CGFloat(B) / 255.0,
      alpha: CGFloat(A))
  }
  
  convenience init(R: Int, G: Int, B: Int) {
    self.init(R: R, G: G, B: B, A: 1.0)
  }
  
  convenience init(HEX value: Int, withAlpha aValue: Float) {
    self.init(
      R: (value >> 16) & 0xFF,
      G: (value >> 8) & 0xFF,
      B: value & 0xFF,
      A: aValue)
  }
  
  convenience init(HEX value: Int) {
    self.init(HEX: value, withAlpha: 1.0)
  }
  
  @available(iOS 10.0, *)
  convenience init(displayP3R: Int, G: Int, B: Int, A: Float) {
    assert(0...255 ~= displayP3R, "Invalid red component in P3")
    assert(0...255 ~= G, "Invalid green component in P3")
    assert(0...255 ~= B, "Invalid blue component in P3")
    assert(0.0...1.0 ~= A, "Invalid Alpha component in P3")
    
    self.init(
      displayP3Red: CGFloat(displayP3R),
      green: CGFloat(G),
      blue: CGFloat(B),
      alpha: CGFloat(A))
  }
  
  @available(iOS 10.0, *)
  convenience init(displayP3R: Int, G: Int, B: Int) {
    self.init(displayP3R: displayP3R, G: G, B: B, A: 1.0)
  }
  
  @available(iOS 10.0, *)
  convenience init(displayP3HEX value: Int, withAlpha aValue: Float) {
    self.init(
      displayP3R: (value >> 16) & 0xFF,
      G: (value >> 8) & 0xFF,
      B: value & 0xFF,
      A: aValue)
  }
  
  @available(iOS 10.0, *)
  convenience init(displayP3HEX value: Int) {
    self.init(displayP3HEX: value, withAlpha: 1.0)
  }
}

// MARK: - UIAlertController extension
public extension UIAlertController {
  func addActions(_ actions: [UIAlertAction]) { actions.forEach { addAction($0) } }
  
  convenience init(title: String?, message: String?, actions: [UIAlertAction]? = nil) {
    self.init(title: title, message: message, preferredStyle: .alert)

    view.tintColor = .black
    
    if actions != nil { addActions(actions!) }
  }
}

public extension UIAlertAction {
  convenience init(title: String?, tintColor: UIColor = .black, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) {
    self.init(title: title, style: style, handler: handler)
    
    self.setTintColor(tintColor)
  }
  
  func setTintColor(_ color: UIColor) { self.setValue(color, forKey: "titleTextColor") }
}

// MARK: - Async operation
public class AsyncOperation: Operation {
  enum State: String {
    case Ready, Executing, Finished
    
    fileprivate var keyPath: String { "is" + rawValue }
  }
  
  var state = State.Ready {
    willSet {
      willChangeValue(forKey: newValue.keyPath)
      willChangeValue(forKey: state.keyPath)
    }
    didSet {
      didChangeValue(forKey: oldValue.keyPath)
      didChangeValue(forKey: state.keyPath)
    }
  }
}

public extension AsyncOperation {
  override var isReady: Bool { super.isReady && state == .Ready }
  
  override var isExecuting: Bool { state == .Executing }
  
  override var isFinished: Bool { state == .Finished }
  
  override var isAsynchronous: Bool { true }
  
  override func start() {
    if isCancelled {
      state = .Finished
      return
    }
    
    state = .Executing
    main()
    state = .Finished
  }
  
  override func cancel() { state = .Finished }
}

// MARK: - FileManager extension
public extension FileManager {
  static var documentDirectory: URL {
    `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
}

// MARK: - Common error
public enum V2RXError: Error {
  public enum Fatal: Error {
    case location(method: String)
  }
  
  public enum DataAccessObjects: Error {
    case invalidData
    case notFound
    case invalidForeignKey
    case unexpected
  }
}

extension V2RXError: LocalizedError {
  static func printError(_ error: Error) {
    print(
      "V2RXError:\nDescription: \(error.localizedDescription)\n" +
      "Function name: \(#function)\nFile: \(#file), Line: \(#line)"
    )
  }
}

public extension V2RXError.Fatal {
  var localizedDescription: String {
    switch self {
      case let .location(method):
      return "\(method) has not been implemented"
    }
  }
}

public extension V2RXError.DataAccessObjects {
  var localizedDescription: String {
    switch self {
      case .invalidData:
        return "Data is invalid!"
      case .invalidForeignKey:
        return "Foreign key is invalid!"
      case .notFound:
        return "Data is not found!"
      case .unexpected:
        return "Unexpected: catch it from Data Access Object ERROR!"
    }
  }
}

// MARK: - UIViewController extension
public extension UIViewController {
  func prepareMove(toParent: UIViewController?, catching handle: @escaping () -> Void) {
    DispatchQueue.main.async {
      self.willMove(toParent: toParent)
      handle()
      self.didMove(toParent: toParent)
    }
  }
}
