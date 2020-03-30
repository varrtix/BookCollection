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
  
  fileprivate lazy var collecitonView = launchCollectionView()
  
  fileprivate var books = [BCBook]()
  
  private let numbersOfPerRow: CGFloat = 3
  
  private let paddingInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
  
  private let defaultPageSize = 100
}

// MARK: - View life-cycle
extension BCListCollectionViewController {
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
extension BCListCollectionViewController {
  fileprivate func loadData(withOffset: Int, pageSize: Int) {
    BCBookListService.getAllBooks(withOffset: withOffset, andSize: pageSize) {
      BCDBResult.handle($0, success: {
        self.books = $0
        self.collecitonView.reloadData()
      }) { V2RXError.printError($0) }
    }
  }
}

// MARK: - View controllers
extension BCListCollectionViewController {
  fileprivate func launch() {
    loadData(withOffset: 0, pageSize: defaultPageSize)
  }
  
  fileprivate func wakeup() {
    
  }
  
  fileprivate func launchCollectionView() -> UICollectionView {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(
      frame: view.frame,
      collectionViewLayout: layout)
    
    collectionView.backgroundColor = BCColor.ListTint.snowWhite
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.register(BCListCollectionViewCell.self, forCellWithReuseIdentifier: "BCListCollectionViewCell")
    
    view.addSubview(collectionView)

    return collectionView
  }
}

// MARK: - Collectionview delegate
extension BCListCollectionViewController: UICollectionViewDelegate {
}

// MARK: - Collectionview datasource
extension BCListCollectionViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int { books.count }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let identifier = "BCListCollectionViewCell"
    
    var cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? BCListCollectionViewCell
//    cell.image
    if cell == nil {
      cell = BCListCollectionViewCell()
    }
    cell!.inject(book: books[indexPath.row])
    
    return cell!
  }
}

// MARK: Collectionview flowlayout delegate
extension BCListCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let paddingSpace = paddingInset.left * (numbersOfPerRow + 1)
    let width = ((view.frame.width - paddingSpace) / numbersOfPerRow).rounded(.towardZero)
    let height = width / 5 * 7 + 5 + 16 + 20

    return CGSize(width: width, height: height)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets { paddingInset }
}
