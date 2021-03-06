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

private let cellIdentifier = BCMapping.CellIdentifier.listTableView.rawValue

final class BCListTableViewController: BCViewController {
  
  private let bookShelf = BCBookshelf.shared
  
  private let tableViewDataSource = ListTableViewDataSource(withCellReuseIdentifier: cellIdentifier)
  
  private lazy var tableView: UITableView! = {
    let tableView = UITableView(frame: view.frame, style: .plain)
    
    tableView.backgroundColor = BCColor.ListTint.snowWhite
    tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    tableView.tableFooterView = UIView()
    
    tableView.delegate = self
    
    tableView.dataSource = tableViewDataSource
    
    tableView.prefetchDataSource = tableViewDataSource
    
    tableView.register(BCListTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    
    return tableView
  }()
  
  deinit {
    NotificationCenter.default.removeObserver(
      self,
      name: BCBookshelf.changedNotification,
      object: nil
    )
  }
}

// MARK: - View life-cycle
extension BCListTableViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleChangeNotification(_:)),
      name: BCBookshelf.changedNotification,
      object: nil
    )
    
    view = tableView
  }
}

// MARK: - View controllers
extension BCListTableViewController {

  @objc
  private func handleChangeNotification(_ notification: Notification) {
    guard let key = notification.userInfo?[BCBookshelf.ChangedNotification.reasonKey]
      as? BCBookshelf.ChangedNotification.ReasonKey
      else { return }
    
    DispatchQueue.main.async {
      if key == .append,
        let index = notification.userInfo?[BCBookshelf.ChangedNotification.ValueCache.newValueKey] as? Int {
        self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
      } else if key == .remove,
        let index = notification.userInfo?[BCBookshelf.ChangedNotification.ValueCache.oldValueKey] as? Int {
        self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
      } else if key == .multiLoadingComplete {
        self.tableView.reloadData()
      }
    }
  }
}

// MARK: - Tableview delegate
extension BCListTableViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat { 100.0 }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let infoViewController = BCInfoViewController(with: bookShelf[indexPath.row])
    let navigationController = BCNavigationController(rootViewController: infoViewController)
    present(navigationController, animated: true)
  }
}
