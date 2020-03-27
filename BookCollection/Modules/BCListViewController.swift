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

class BCListViewController: BCViewController {
  
  fileprivate enum Mode: String {
    case table, collection
    
    mutating func toggle() {
      switch self {
        case .table: self = .collection
        case .collection: self = .table
      }
    }
  }
  
  lazy fileprivate var scan: ViewTuple = ("Scan", BCScanViewController())
  
  fileprivate var _mode = Mode.table {
    willSet {
      DispatchQueue.main.async {
        guard self.navigationItem.leftBarButtonItem != nil else { return }
        self.navigationItem
          .leftBarButtonItem?
          .image = UIImage(named: "Main/List/Mode-\(newValue.rawValue)")
        switch newValue {
          case .table: break
          case .collection: break
        }
      }
    }
  }
}

// MARK: - View Life-cycle
extension BCListViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemTeal
    configureNavigationBar()
  }
}

// MARK: - Navigation Bar
extension BCListViewController {
  fileprivate func configureNavigationBar() {
    navigationItem.title = "BookCollection"
    
    let scanButtonItem = UIBarButtonItem(
      image: UIImage(named: "Main/\(scan.title)"),
      style: .plain,
      target: self,
      action: #selector(scan(_:)))
    
    let modeButtonItem = UIBarButtonItem(
      image: UIImage(named: "Main/List/Mode-\(_mode.rawValue)"),
      style: .plain,
      target: self,
      action: #selector(switchMode(_:)))
    
    navigationItem.rightBarButtonItem = scanButtonItem
    navigationItem.leftBarButtonItem = modeButtonItem
    
  }
  
  // MARK: Button Actions
  @objc
  func scan(_ sender: UIBarButtonItem) {
    let navigation = BCNavigationController(rootViewController: scan.item)
    
    present(navigation, animated: true)
  }
  
  @objc
  func switchMode(_ sender: UIBarButtonItem) { _mode.toggle() }
}
