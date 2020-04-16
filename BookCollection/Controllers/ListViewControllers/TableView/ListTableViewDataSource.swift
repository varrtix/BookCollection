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

final class ListTableViewDataSource: NSObject, UITableViewDataSource {
  var bookShelf = BCBookshelf.shared
  
  private let cellIdentifier = "BCListTableViewCell"
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { bookShelf.count }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
    as? BCListTableViewCell
    
    if cell == nil {
      cell = BCListTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
    }
    cell?.inject(book: bookShelf[indexPath.row])
    
    if cell?.cover == nil, !tableView.isDragging && !tableView.isDecelerating {
      cell?.loadingImage(with: bookShelf[indexPath.row].image)
    }

    return cell!
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    switch editingStyle {
      case .delete: bookShelf.remove(bookShelf[indexPath.row])
      default: break
    }
  }
}

extension ListTableViewDataSource: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    indexPaths.forEach {
      if let cell = tableView.cellForRow(at: $0) as? BCListTableViewCell, cell.cover == nil {
        cell.loadingImage(with: bookShelf[$0.row].image)
      }
    }
  }
  
  func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    indexPaths.forEach {
      if let cell = tableView.cellForRow(at: $0) as? BCListTableViewCell {
        cell.cancelLoadingImage()
      }
    }
  }
}
