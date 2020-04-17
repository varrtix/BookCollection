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

final class ListCollectionViewDataSource: NSObject, UICollectionViewDataSource {
  
  private let bookShelf = BCBookshelf.shared
  
  private let cellIdentifier: String
  
  private var collectionView: UICollectionView?
  
  init(withCellReuseIdentifier: String) {
    self.cellIdentifier = withCellReuseIdentifier
    
    super.init()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    self.collectionView = collectionView
    return bookShelf.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
    
    if let cell = cell as? BCListCollectionViewCell {
      cell.dataSource = self
      cell.inject(book: bookShelf[indexPath.row])
      
      if let url = bookShelf.snapshotURLs[indexPath.row] {
        cell.loadingImage(with: url)
      } else if let url = URL(string: bookShelf[indexPath.row].image ?? "") {
        cell.loadingImage(with: url)
      }
    }
    
    return cell
  }
}

extension ListCollectionViewDataSource: UICollectionViewDataSourcePrefetching {
  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    bookShelf.prefetching(by: Set(indexPaths.map { $0.row }))
  }
  
  func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {}
}

extension ListCollectionViewDataSource: BCListCollectionViewCellDataSource {
  func removeCell(_ cell: BCListCollectionViewCell) {
    guard let indexPath = collectionView?.indexPath(for: cell)
      else { return }
    bookShelf.remove(bookShelf[indexPath.row])
  }
}
