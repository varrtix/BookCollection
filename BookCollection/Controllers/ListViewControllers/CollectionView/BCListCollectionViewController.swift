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

class BCListCollectionViewController: BCViewController {
  
  private let numbersOfPerRow: CGFloat = 3
  
  private let paddingInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
  
  private let collectionViewDataSource = ListCollectionViewDataSource()
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(
      frame: view.frame,
      collectionViewLayout: layout)
    
    collectionView.backgroundColor = BCColor.ListTint.snowWhite
    
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    collectionView.delegate = self
    
    collectionView.dataSource = self.collectionViewDataSource
    
    collectionView.prefetchDataSource = self.collectionViewDataSource
    
    collectionView.register(BCListCollectionViewCell.self, forCellWithReuseIdentifier: "BCListCollectionViewCell")
    
    view.addSubview(collectionView)
    
    return collectionView
  }()

  deinit {
    NotificationCenter.default.removeObserver(self, name: BCBookshelf.changedNotification, object: nil)
  }
}

// MARK: - View life-cycle
extension BCListCollectionViewController {
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
extension BCListCollectionViewController {
}

// MARK: - View controllers
extension BCListCollectionViewController {
  fileprivate func launch() {
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleChangeNotification(_:)), name: BCBookshelf.changedNotification, object: nil)
    
    let longPressGesture = UILongPressGestureRecognizer(
      target: self,
      action: #selector(longPressHandler(_:))
    )
    
    collectionView.addGestureRecognizer(longPressGesture)
  }
  
  fileprivate func wakeup() {
  }
  
  @objc
  private func handleChangeNotification(_ notification: Notification) {
    guard let key = notification.userInfo?[BCBookshelf.ChangedNotification.reasonKey] as? BCBookshelf.ChangedNotification.ReasonKey
      else { return }
    
    if key == .append,
      let index = notification.userInfo?[BCBookshelf.ChangedNotification.ValueCache.newValueKey] as? Int {
      collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    } else if key == .remove,
      let index = notification.userInfo?[BCBookshelf.ChangedNotification.ValueCache.oldValueKey] as? Int {
      collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
    }
  }
}

// MARK: - Collectionview delegate
extension BCListCollectionViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if
      let cell = collectionView.cellForItem(at: indexPath)
        as? BCListCollectionViewCell,
      cell.isEditing == true {
      cell.isEditing = false
      collectionView.deselectItem(at: indexPath, animated: true)
    }
  }
}

// MARK: - Collectionview datasource
//extension BCListCollectionViewController: UICollectionViewDataSource {
//  func collectionView(
//    _ collectionView: UICollectionView,
//    numberOfItemsInSection section: Int
//  ) -> Int { books.count }
//
//  func collectionView(
//    _ collectionView: UICollectionView,
//    cellForItemAt indexPath: IndexPath
//  ) -> UICollectionViewCell {
//    let identifier = "BCListCollectionViewCell"
//
//    var cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? BCListCollectionViewCell
////    cell.image
//    if cell == nil {
//      cell = BCListCollectionViewCell()
//    }
//    cell?.inject(book: books[indexPath.row])
//    cell?.delegate = self
//
//    if cell?.cover == nil,
//      !collectionView.isDragging && !collectionView.isDecelerating {
//      cell?.loadingImage(with: books[indexPath.row].image)
//    }
//
//    return cell!
//  }
//}

// MARK: - Collectionview flowlayout delegate
extension BCListCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let paddingSpace = paddingInset.left * (numbersOfPerRow + 1)
    let width = ((view.frame.width - paddingSpace) /
      numbersOfPerRow).rounded(.towardZero)
    let height = width / 5 * 7 + 5 + 16 + 20

    return CGSize(width: width, height: height)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets { paddingInset }
}

// MARK: Collectionview actions
extension BCListCollectionViewController {
  @objc
  func longPressHandler(_ sender: UILongPressGestureRecognizer) {
    let points = sender.location(in: collectionView)
    guard
      let indexPath = collectionView.indexPathForItem(at: points),
      sender.state == .began
      else { return }
    let cell = collectionView.cellForItem(at: indexPath) as! BCListCollectionViewCell
    cell.isEditing = true
  }
}

// MARK: - Collectionview cell delegate
//extension BCListCollectionViewController: BCListCollectionViewCellDataSource {
//  func removeCell(_ cell: BCListCollectionViewCell) {
//    guard let indexPath = collectionView.indexPath(for: cell)
//      else { return }
//    // MARK: delete row on database
//    BCBookInfoService.unmark(by: books[indexPath.row].doubanID) {
//      BCResponse.handle($0, success: { _ in
//        self.books.remove(at: indexPath.row)
//        self.collecitonView.deleteItems(at: [indexPath])
//      }) { V2RXError.printError($0) }
//    }
    
//  }
//}

// MARK: - Scrollview delegate
//extension BCListCollectionViewController {
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
//    collecitonView.visibleCells.forEach {
//      if let cell = $0 as? BCListCollectionViewCell,
//        let indexPath = collecitonView.indexPath(for: cell) {
//        if cell.cover == nil {
//          cell.loadingImage(with: books[indexPath.row].image)
//        }
//      }
//    }
//  }
//}
