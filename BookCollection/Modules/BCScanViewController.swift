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

class BCScanViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .red
    
    loadNavigation()
    loadSubviews()
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
    navigationItem.leftBarButtonItem = loadButton("Scan/back-button", action: #selector(back))
    navigationItem.rightBarButtonItem = loadButton("Scan/light-off", and: "Scan/light-on", action: #selector(light(_:)))
  }
  
  // loadButton
  fileprivate func loadButton(_ imageNamed: String, and selectImageNamed: String? = nil, action: Selector) -> some UIBarButtonItem {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: imageNamed), for: .normal)
    button.tintColor = .white
    button.sizeToFit()
    
    if let name = selectImageNamed { button.setImage(UIImage(named: name), for: .selected) }
    
    button.addTarget(self, action: action, for: .touchUpInside)
    
    return UIBarButtonItem(customView: button)
  }
  
  // BarButton Actions
  @objc fileprivate func back() { dismiss(animated: true) }
  
  @objc fileprivate func light(_ sender: UIButton) {
    sender.isSelected.toggle()
    // TODO: Turn on and off the light.
  }
}

// MARK: - Subviews
extension BCScanViewController {
  fileprivate func loadSubviews() {
    
  }
}
