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
import Kingfisher

class BCInfoViewController: BCViewController {
  
  fileprivate var topDistance: CGFloat {
    if #available(iOS 13.0, *) {
      return 20.0
    } else {
      let barHeight = navigationController?.navigationBar.frame.height ?? 44.0
      let statusHeight = UIApplication.shared.isStatusBarHidden ?
        20.0 : UIApplication.shared.statusBarFrame.height
      
      return barHeight + statusHeight
    }
  }
  
  private lazy var infoView = BCInfoView(frame: view.frame, withScrollView: topDistance)
  
  private let book: BCBook!
  
  private let bookShelf = BCBookshelf.shared
  
  private let defaultMarked: Bool
  
  init(with book: BCBook) {
    self.book = book
    self.defaultMarked = book.isMarked
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - View controller life-cycle
extension BCInfoViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup(navigationItem)
    
    setup(view)
    
    infoView.delegate = self
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    if !book.isMarked && defaultMarked {
      bookShelf.remove(book)
    } else if book.isMarked && !defaultMarked {
      bookShelf.append(book)
    }
  }
}

// MARK: - View configure
extension BCInfoViewController {
  
  fileprivate func setup(_ item: UINavigationItem) {
    item.title = book?.title ?? "Book Information"
    
    navigationBarBackgroundImage = UIImage()
    
    shouldShowShadowImage = false
    
    shouldHideBottomBarWhenPushed = true
    
    if #available(iOS 13.0, *) {} else {
      item.leftBarButtonItem = UIBarButtonItem(
        title: "Back",
        style: .plain,
        target: self,
        action: #selector(close(_:)))
    }
  }
  // MARK: configure Subviews
  fileprivate func setup(_ view: UIView) {
    
    view.backgroundColor = BCColor.BarTint.white
    
    view.addSubview(infoView)
  }
}

// MARK: - Actions
@objc
extension BCInfoViewController {
  private func close(_ sender: UIBarButtonItem? = nil) {
    dismiss(animated: true)
  }
}

// MARK: - BCInfoView Delegate
extension BCInfoViewController: BCInfoViewDelegate {
  var titleText: String {
    book.title ?? ""
  }
  
  var detailTexts: [String] {
    var items = [String]()
    
    if let authors = book.authors, !authors.isEmpty {
      var author = ""
      authors.forEach { author += $0 + " " }
      items.append("Author: \(author)")
    }
    
    if let translators = book.translators, !translators.isEmpty {
      var translator = ""
      translators.forEach { translator += $0 + " " }
      items.append("Translator: \(translator)")
    }
    
    if book.publisher != nil { items.append("Publisher: \(book!.publisher!)") }
    
    if book?.publishedDate != nil { items.append("Published Date: \(book!.publishedDate!)") }
    
    if book?.price != nil { items.append("Price: \(book!.price!)") }
    
    if let isbn = book?.isbn13 {
      items.append("ISBN: \(isbn)")
    } else if let isbn = book?.isbn10 {
      items.append("ISBN: \(isbn)")
    }
    
    return items
  }
  
  var summaryText: String {
    book.summary ?? ""
  }
  
  var isMarked: Bool { book.isMarked }
  
  func coverImageViewDidLoad(_ cover: UIImageView) {
    if let imageURL = book.image {
      cover.kf.setImage(with: URL(string: imageURL))
    }
  }
  
  func didFinishingMark(by button: UIButton?) -> Bool {
    book.isMarked.toggle()
    
    return book.isMarked
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    infoView.backgroundImageView.layer.frame = CGRect(
      x: 0,
      y: 0,
      width: view.frame.width,
      height: scrollView.contentOffset.y < 0 ?
        infoView.backgroundHeight - scrollView.contentOffset.y : infoView.backgroundHeight
    )
  }
}
