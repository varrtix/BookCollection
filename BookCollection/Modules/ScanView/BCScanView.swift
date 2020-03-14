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

class BCScanView: UIView {
  fileprivate typealias Point = (x: CGFloat, y: CGFloat)
  /// The size of scanning rectangle
  fileprivate var size: CGSize
  /// The offset value relative to the center point in the axis of Y.
  /// The positive direction is going down
  fileprivate var verticalOffset: CGFloat
  /// Scan Line
  lazy fileprivate var animationLine = UIImageView(frame: CGRect(
    x: upperLeftPoint.x,
    y: upperLeftPoint.y,
    width: size.width,
    height: 1.0))
  
  // Key pointers
  fileprivate var upperLeftPoint: Point
  fileprivate var upperRightPoint: Point
  fileprivate var lowerLeftPoint: Point
  fileprivate var lowerRightPoint: Point
  
  fileprivate var animationReverse = false
  private var _isAnimating = false
  
  var isAnimating: Bool { _isAnimating }
  
  init(_ frame: CGRect, rect size: CGSize, vertical offset: CGFloat) {
    self.size = size
    self.verticalOffset = offset
    // Computed reference coordinates
    upperLeftPoint = (
      (frame.width - size.width) / 2, (frame.height - size.height) / 2 + verticalOffset
    )
    upperRightPoint = (
      upperLeftPoint.x + size.width, upperLeftPoint.y
    )
    lowerLeftPoint = (
      upperLeftPoint.x, upperLeftPoint.y + size.height
    )
    lowerRightPoint = (
      upperRightPoint.x, lowerLeftPoint.y
    )
    
    super.init(frame: frame)
    
    addSubview(animationLine)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else { return }
    
    // Draw the translucent black area
    drawOuterArea(context)
    
    // Draw the white boarder around the center area
    drawBoarder(context)
    
    // Draw four white corners around the center area
    drawBoarderCorners(context)
  }
}

// MARK: - Draw View
extension BCScanView {
  /// Draw the translucent black area
  /// - Parameter context: CGContext
  fileprivate func drawOuterArea(_ context: CGContext) {
    context.setFillColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    
    context.fill([
      // Top area
      CGRect(x: 0, y: 0, width: frame.width, height: upperLeftPoint.y),
      // Bottom area
      CGRect(x: 0, y: lowerLeftPoint.y,
             width: frame.width, height: frame.height - lowerLeftPoint.y),
      // Left area
      CGRect(x: 0, y: upperLeftPoint.y,
             width: upperLeftPoint.x, height: size.height),
      // Right area
      CGRect(x: upperRightPoint.x, y: upperRightPoint.y,
             width: frame.width - upperRightPoint.x, height: size.height),
    ])
  }
  
  /// Draw the white boarder around the center area
  /// - Parameter context: CGContext
  fileprivate func drawBoarder(_ context: CGContext) {
    context.setStrokeColor(UIColor.white.cgColor)
    
    context.stroke(CGRect(
      x: upperLeftPoint.x,
      y: upperLeftPoint.y,
      width: size.width,
      height: size.height), width: 0.5)
  }
  
  /// Draw four white corners around the center area
  /// - Parameter context: CGContext
  fileprivate func drawBoarderCorners(_ context: CGContext) {
    let cornerLength: CGFloat = 9.0
    let cornerThick: CGFloat = 1.0
    let offset = cornerLength - cornerThick
    
    context.setLineWidth(cornerThick)
    context.setStrokeColor(UIColor.white.cgColor)
    
    // The upper left corner
    context.addLines(between: [
      CGPoint(x: upperLeftPoint.x - cornerThick,
              y: upperLeftPoint.y + offset),
      CGPoint(x: upperLeftPoint.x - cornerThick,
              y: upperLeftPoint.y - cornerThick),
      CGPoint(x: upperLeftPoint.x + offset,
              y: upperLeftPoint.y - cornerThick),
    ])
    // The upper right corner
    context.addLines(between: [
      CGPoint(x: upperRightPoint.x - offset,
              y: upperRightPoint.y - cornerThick),
      CGPoint(x: upperRightPoint.x + cornerThick,
              y: upperRightPoint.y - cornerThick),
      CGPoint(x: upperRightPoint.x + cornerThick,
              y: upperRightPoint.y + offset),
    ])
    // The lower left corner
    context.addLines(between: [
      CGPoint(x: lowerLeftPoint.x - cornerThick,
              y: lowerLeftPoint.y - offset),
      CGPoint(x: lowerLeftPoint.x - cornerThick,
              y: lowerLeftPoint.y + cornerThick),
      CGPoint(x: lowerLeftPoint.x + offset,
              y: lowerLeftPoint.y + cornerThick),
    ])
    // the lower right corner
    context.addLines(between: [
      CGPoint(x: lowerRightPoint.x - offset,
              y: lowerRightPoint.y + cornerThick),
      CGPoint(x: lowerRightPoint.x + cornerThick,
              y: lowerRightPoint.y + cornerThick),
      CGPoint(x: lowerRightPoint.x + cornerThick,
              y: lowerRightPoint.y - offset),
    ])
    
    context.strokePath()
  }
}

// MARK: - AnimationLine
extension BCScanView {
  /// Start scan line animation
  func startAnimating() {
    if _isAnimating { return }
    
    if animationLine.image == nil {
      animationLine.image = UIImage(named: "Scan/scanner-line")
    }
    
    _isAnimating = true
    
    UIView.animate(withDuration: 3.0, delay: 0.5, options: .curveEaseInOut, animations: {
      self.animationLine.frame = self.animationReverse ?
        CGRect(x: self.upperLeftPoint.x, y: self.upperLeftPoint.y,
               width: self.size.width, height: 1.0) :
        CGRect(x: self.lowerLeftPoint.x, y: self.lowerLeftPoint.y,
               width: self.size.width, height: 1.0)
    }) { completed in
      
      if completed {
        self.animationReverse.toggle()
        self._isAnimating = false
        
        self.startAnimating()
        
      } else {
        self.stopAnimating()
      }
    }
  }
  
  func stopAnimating() {
    animationLine.removeFromSuperview()
    animationLine.image = nil
    
    _isAnimating = false
    animationReverse = false
    
  }
}
