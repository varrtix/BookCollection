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
import ESPullToRefresh

class BCListTableViewController: BCViewController {
  
  fileprivate enum State {
    case ready, start, wait, stop
  }
  
  fileprivate var state = State.stop {
    willSet {
      switch newValue {
        case .ready:
          launch()
        case .start:
          wakeup()
        case .wait: break
        case .stop: break
      }
    }
  }
  
  fileprivate lazy var tableView = launchTableView()
  
  fileprivate var books = [BCBook]()
  
  private var booksCount: Int {
    var count = 0
    BCBookListService.getBooksCount {
      BCDBResult.handle($0, success: { value in
        count = value
      })
    }
    return count
  }
  
  private var pageOffset = 0
  private let defaultPageSize = 5
}

// MARK: - View life-cycle
extension BCListTableViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    state = .ready
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    state = .start
  }
}

// MARK: - Data
extension BCListTableViewController {
  fileprivate func loadData() {
    if pageOffset == 0 { books.removeAll() }
    
    BCBookListService.getAllBooks(withOffset: pageOffset, andSize: defaultPageSize) {
      BCDBResult.handle($0, success: {
        self.books += $0
        
        self.tableView.reloadData()
        self.tableView.es.stopLoadingMore()
        
        self.pageOffset += self.defaultPageSize
      }) { V2RXError.printError($0) }
    }
  }
}

// MARK: - View controllers
extension BCListTableViewController {
  fileprivate func launch() {
    loadData()
  }
  
  fileprivate func wakeup() {
  }
  
  fileprivate func launchTableView() -> UITableView {
    let tableView = UITableView(frame: view.frame, style: .plain)
    
    tableView.backgroundColor = BCColor.ListTint.snowWhite
    tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    tableView.tableFooterView = UIView()
    tableView.delegate = self
    tableView.dataSource = self
    
    view.addSubview(tableView)
    
    tableView.es.addInfiniteScrolling { [unowned self] in
      if self.pageOffset > self.booksCount {
        self.tableView.es.noticeNoMoreData()
      }
      
      self.loadData()
    }

    return tableView
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
extension BCListTableViewController: UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int { books.count }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt
    indexPath: IndexPath
  ) -> UITableViewCell {
    let identifier = "BCListTableViewCell"
    
    var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? BCListTableViewCell
    
    if cell == nil {
      cell = BCListTableViewCell(style: .default, reuseIdentifier: identifier)
    }
    cell?.inject(book: books[indexPath.row])
    
    if cell?.cover == nil,
      !tableView.isDragging && !tableView.isDecelerating {
      cell?.loadingImage(with: books[indexPath.row].image)
    }
    
    return cell!
  }
  
  func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath
  ) {
    switch editingStyle {
      case .delete:
        BCBookInfoService.unmark(by: books[indexPath.row].doubanID) {
          BCDBResult.handle($0, success: { _ in
            self.books.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
          }) { V2RXError.printError($0) }
      }
      default: break
    }
  }
}

// MARK: - Scrollview delegate
extension BCListTableViewController {
  func scrollViewDidEndDragging(
    _ scrollView: UIScrollView,
    willDecelerate decelerate: Bool) {
    if !decelerate {
      loadingCoversForVisibleCells()
    }
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    loadingCoversForVisibleCells()
  }
  
  fileprivate func loadingCoversForVisibleCells() {
    tableView.visibleCells.forEach {
      if let cell = $0 as? BCListTableViewCell,
        let indexPath = tableView.indexPath(for: cell) {
        if cell.cover == nil {
          cell.loadingImage(with: books[indexPath.row].image)
        }
      }
    }
  }
}
