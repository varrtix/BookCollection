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
  
  fileprivate enum State {
    case ready, start, editing, wait, stop
  }
  
  fileprivate var state = State.stop {
    willSet {
      switch newValue {
        case .ready:
          launch()
        case .start:
          wakeup()
        case .editing: break
        case .wait: break
        case .stop: break
      }
    }
  }
  
  fileprivate lazy var tableView = launchTableView()
  
  fileprivate var books = [BCBook]() {
    willSet {}
  }
}

// MARK: View life-cycle
extension BCListTableViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //    view.backgroundColor = .systemRed
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
    BCBookListService.getAllBooks {
      BCDBResult.handle($0, success: {
        self.books = $0
        self.tableView.reloadData()
      }) { V2RXError.printError($0) }
    }
  }
}

// MARK: - View controllers
extension BCListTableViewController {
  fileprivate func launch() {
    loadData()
    //    tableView.reloadData()
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
    cell!.inject(book: books[indexPath.row])
    
    return cell!
  }
}
