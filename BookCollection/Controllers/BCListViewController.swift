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

final class BCListViewController: BCViewController {
  
  private enum ViewMode: String {
    case table, collection
    
    mutating func toggle() {
      switch self {
        case .table: self = .collection
        case .collection: self = .table
      }
    }
  }
  
  private var modeImage: UIImage? { UIImage(named: "Main/List/Mode-\(viewMode.rawValue)") }
  
  private var viewMode = ViewMode.table {
    didSet {
      DispatchQueue.main.async {
        self.navigationItem.leftBarButtonItem?.image = self.modeImage
        self.toggleController(mode: self.viewMode)
      }
    }
  }
  
  private lazy var scanBarButton = UIBarButtonItem(
    image: UIImage(named: "Main/\(BCMapping.ViewControllers.scan.rawValue)"),
    style: .plain,
    target: self,
    action: #selector(scan(_:))
  )
  
  private lazy var modeBarButton = UIBarButtonItem(
    image: self.modeImage,
    style: .plain,
    target: self,
    action: #selector(toggleMode(_:))
  )
}

// MARK: - View Life-cycle
extension BCListViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = BCColor.ListTint.snowWhite
    setup(navigationItem)
    viewMode = .table
  }
}


// MARK: - view configurations
extension BCListViewController {
  
  private func toggleController(mode: ViewMode) {
    prepareMove(toParent: nil) {
      self.children.forEach {
        $0.removeFromParent()
        $0.view.removeFromSuperview()
      }
    }
    
    let viewController = mode == .table ?
      BCMapping.ViewControllers.tableList.raw :
      BCMapping.ViewControllers.collectionList.raw
    
    prepareMove(toParent: self) {
      self.addChild(viewController)
      self.view.addSubview(viewController.view)
      viewController.view.frame = self.view.bounds
    }
  }
  
  private func setup(_ item: UINavigationItem) {
    item.title = "BookCollection"
    
    item.leftBarButtonItem = modeBarButton
    item.rightBarButtonItem = scanBarButton
  }
}

// MARK: - Button Actions
@objc
private extension BCListViewController {
  
  func scan(_ sender: UIBarButtonItem) {
    let navigationController = BCNavigationController(
      rootViewController: BCMapping.ViewControllers.scan.raw
    )
    
    present(navigationController, animated: true)
  }
  
  func toggleMode(_ sender: UIBarButtonItem) { viewMode.toggle() }
}
