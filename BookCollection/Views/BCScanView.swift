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

final class BCScanView: UIView {
  
  enum State: String {
    case start, running, stop
  }
  
  private typealias Point = (x: CGFloat, y: CGFloat)
  /// The size of scanning rectangle
  private let size: CGSize
  /// The offset value relative to the center point in the axis of Y.
  /// The positive direction is going down
  private let verticalOffset: CGFloat
  /// Scan Line
  private var animationLine: UIImageView?
  
  private var state = State.stop {
    willSet {
      switch newValue {
        case .start:
          animationLine = {
            let imageView = UIImageView(frame: CGRect(
              x: upperLeft.x,
              y: upperLeft.y,
              width: size.width,
              height: 1.0))
            
            imageView.image = UIImage(named: "Scan/scanner-line")
            
            return imageView
          }()
          
          if animationLine != nil {
            addSubview(animationLine!)
        }
        
        case .stop:
          layer.removeAllAnimations()
          animationLine?.removeFromSuperview()
          animationLine = nil
        
        default: break
      }
    }
  }
  
  // Key pointers
  private var upperLeft: Point {
    ((frame.width - size.width) / 2, (frame.height - size.height) / 2 + verticalOffset)
  }
  
  private var upperRight: Point {
    (upperLeft.x + size.width, upperLeft.y)
  }
  
  private var lowerLeft: Point {
    (upperLeft.x, upperLeft.y + size.height)
  }
  
  private var lowerRight: Point {
    (upperRight.x, lowerLeft.y)
  }
  
  var isAnimating: Bool { state == .running }
  
  init(frame: CGRect, scannerSize: CGSize, verticalOffset: CGFloat) {
    self.size = scannerSize
    self.verticalOffset = verticalOffset
    
    super.init(frame: frame)
    
    autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    backgroundColor = .clear
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience override init(frame: CGRect) {
    self.init(frame: frame, scannerSize: Constraint.size, verticalOffset: Constraint.verticalOffset)
  }
}

// MARK: - Draw View
extension BCScanView {
  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else { return }
    
    // Draw the translucent black area
    drawOuterArea(context)
    
    // Draw the white boarder around the center area
    drawBoarder(context)
    
    // Draw four white corners around the center area
    drawBoarderCorners(context)
  }
  //}
  
  /// Draw the translucent black area
  /// - Parameter context: CGContext
  private func drawOuterArea(_ context: CGContext) {
    context.setFillColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    
    context.fill([
      // Top area
      CGRect(x: 0, y: 0, width: frame.width, height: upperLeft.y),
      // Bottom area
      CGRect(x: 0, y: lowerLeft.y,
             width: frame.width, height: frame.height - lowerLeft.y),
      // Left area
      CGRect(x: 0, y: upperLeft.y,
             width: upperLeft.x, height: size.height),
      // Right area
      CGRect(x: upperRight.x, y: upperRight.y,
             width: frame.width - upperRight.x, height: size.height),
    ])
  }
  
  /// Draw the white boarder around the center area
  /// - Parameter context: CGContext
  private func drawBoarder(_ context: CGContext) {
    context.setStrokeColor(UIColor.white.cgColor)
    
    context.stroke(CGRect(
      x: upperLeft.x,
      y: upperLeft.y,
      width: size.width,
      height: size.height), width: 0.5)
  }
  
  /// Draw four white corners around the center area
  /// - Parameter context: CGContext
  private func drawBoarderCorners(_ context: CGContext) {
    let cornerLength: CGFloat = 9.0
    let cornerThick: CGFloat = 1.0
    let offset = cornerLength - cornerThick
    
    context.setLineWidth(cornerThick)
    context.setStrokeColor(UIColor.white.cgColor)
    
    // The upper left corner
    context.addLines(between: [
      CGPoint(x: upperLeft.x - cornerThick,
              y: upperLeft.y + offset),
      CGPoint(x: upperLeft.x - cornerThick,
              y: upperLeft.y - cornerThick),
      CGPoint(x: upperLeft.x + offset,
              y: upperLeft.y - cornerThick),
    ])
    // The upper right corner
    context.addLines(between: [
      CGPoint(x: upperRight.x - offset,
              y: upperRight.y - cornerThick),
      CGPoint(x: upperRight.x + cornerThick,
              y: upperRight.y - cornerThick),
      CGPoint(x: upperRight.x + cornerThick,
              y: upperRight.y + offset),
    ])
    // The lower left corner
    context.addLines(between: [
      CGPoint(x: lowerLeft.x - cornerThick,
              y: lowerLeft.y - offset),
      CGPoint(x: lowerLeft.x - cornerThick,
              y: lowerLeft.y + cornerThick),
      CGPoint(x: lowerLeft.x + offset,
              y: lowerLeft.y + cornerThick),
    ])
    // the lower right corner
    context.addLines(between: [
      CGPoint(x: lowerRight.x - offset,
              y: lowerRight.y + cornerThick),
      CGPoint(x: lowerRight.x + cornerThick,
              y: lowerRight.y + cornerThick),
      CGPoint(x: lowerRight.x + cornerThick,
              y: lowerRight.y - offset),
    ])
    
    context.strokePath()
  }
}

// MARK: - AnimationLine
extension BCScanView {

  /// Start scan line animation
  func startAnimating() {
    switch state {
      case .running: return
      case .stop: state = .start
      default: break
    }
    
    #if DEBUG
    assert(
      animationLine != nil,
      "The animation line must be impossible to be nil " +
      "while the property 'state' is \(state.rawValue)"
    )
    #endif
    
    DispatchQueue.main.async {
      self.state = .running
      UIView.animate(
        withDuration: 3.0,
        delay: 0.5,
        options: [.curveEaseInOut, .autoreverse, .repeat],
        animations: {
          self.animationLine?.frame = CGRect(
            x: self.lowerLeft.x,
            y: self.lowerLeft.y,
            width: self.size.width,
            height: 1.0)
      })
    }
  }
  
  func stopAnimating() {
    if isAnimating { state = .stop }
  }
}

private extension BCScanView {
  struct Constraint {
    static let size = CGSize(width: 230.0, height: 230.0)
    static let verticalOffset = CGFloat(-43.0)
  }
}
