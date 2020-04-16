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

class BCListTableViewController: BCViewController {
  
  private let tableViewDataSource = ListTableViewDataSource()
  private lazy var tableView: UITableView = {
    let tableView = UITableView(frame: view.frame, style: .plain)
    
    tableView.backgroundColor = BCColor.ListTint.snowWhite
    tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    tableView.tableFooterView = UIView()
    
    tableView.delegate = self
    
    tableView.dataSource = self.tableViewDataSource
    
    tableView.prefetchDataSource = self.tableViewDataSource
    
    view.addSubview(tableView)

    return tableView
  }()
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: BCBookshelf.changedNotification, object: nil)
  }
}

// MARK: - View life-cycle
extension BCListTableViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    launch()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    wakeup()
  }
}

// MARK: - Data
extension BCListTableViewController {
}

// MARK: - View controllers
extension BCListTableViewController {
  fileprivate func launch() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleChangeNotification(_:)), name: BCBookshelf.changedNotification, object: nil)
  }
  
  fileprivate func wakeup() {
  }
  
  @objc
  private func handleChangeNotification(_ notification: Notification) {
    guard let key = notification.userInfo?[BCBookshelf.ChangedNotification.reasonKey] as? BCBookshelf.ChangedNotification.ReasonKey
      else { return }
    
    if key == .append,
      let index = notification.userInfo?[BCBookshelf.ChangedNotification.ValueCache.newValueKey] as? Int {
      tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    } else if key == .remove,
      let index = notification.userInfo?[BCBookshelf.ChangedNotification.ValueCache.oldValueKey] as? Int {
      tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
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
  }
}

// MARK: - Tableview datasource
//extension BCListTableViewController: UITableViewDataSource {
//  func tableView(
//    _ tableView: UITableView,
//    numberOfRowsInSection section: Int
//  ) -> Int { books.count }
//
//  func tableView(
//    _ tableView: UITableView,
//    cellForRowAt
//    indexPath: IndexPath
//  ) -> UITableViewCell {
//    let identifier = "BCListTableViewCell"
//
//    var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? BCListTableViewCell
//
//    if cell == nil {
//      cell = BCListTableViewCell(style: .default, reuseIdentifier: identifier)
//    }
//    cell?.inject(book: books[indexPath.row])
//
//    if cell?.cover == nil,
//      !tableView.isDragging && !tableView.isDecelerating {
//      cell?.loadingImage(with: books[indexPath.row].image)
//    }
//
//    return cell!
//  }
//
//  func tableView(
//    _ tableView: UITableView,
//    commit editingStyle: UITableViewCell.EditingStyle,
//    forRowAt indexPath: IndexPath
//  ) {
//    switch editingStyle {
//      case .delete:
//        BCBookInfoService.unmark(by: books[indexPath.row].doubanID) {
//          BCResponse.handle($0, success: { _ in
//            self.books.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//          }) { V2RXError.printError($0) }
//      }
//      default: break
//    }
//  }
//}

// MARK: - Scrollview delegate
//extension BCListTableViewController {
//  func scrollViewDidEndDragging(
//    _ scrollView: UIScrollView,
//    willDecelerate decelerate: Bool) {
//    if !decelerate {
//      loadingCoversForVisibleCells()
//    }
//  }
//
//  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//    loadingCoversForVisibleCells()
//  }
//
//  fileprivate func loadingCoversForVisibleCells() {
//    tableView.visibleCells.forEach {
//      if let cell = $0 as? BCListTableViewCell,
//        let indexPath = tableView.indexPath(for: cell) {
//        if cell.cover == nil {
//          cell.loadingImage(with: books[indexPath.row].image)
//        }
//      }
//    }
//  }
//}
