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
import SnapKit
import Kingfisher

class BCInfoViewController: BCViewController {
  
  fileprivate var backgroundHeight: CGFloat = 270.5
  
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
  
  fileprivate var backgroundImageView = UIImageView(image: UIImage(named: "Info/NavigationBar"))
  
  var book: BCBook.Root?
  
  init(with book: BCBook.Root) {
    super.init(nibName: nil, bundle: nil)
    
    self.book = book
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - View controller life-cycle
extension BCInfoViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = BCColor.BarTint.white
    
    configureNavigation()
    configureSubviews()
  }
}

// MARK: - View configure
extension BCInfoViewController {
  
  fileprivate func configureNavigation() {
    navigationItem.title = "Book Information"
    
    navigationBarBackgroundImage = UIImage()
    
    shouldShowShadowImage = false
    
    shouldHideBottomBarWhenPushed = true
  }
  // MARK: configure Subviews
  fileprivate func configureSubviews() {
    configureBackgroundView()
    
    configureScrollView()
  }
  
  fileprivate func configureBackgroundView() {
//    backgroundImageView.frame = CGRect(
//      x: 0,
//      y: 0,
//      width: self.view.frame.width,
//      height: backgroundHeight
//    )
//
//    backgroundImageView.autoresizingMask = .flexibleWidth
//
    view.addSubview(backgroundImageView)
  }
  
  // MARK: Scroll view
  fileprivate func configureScrollView() {
    
    let scrollView = UIScrollView(frame: CGRect(
      x: 0,
      y: topDistance,
      width: self.view.frame.width,
      height: self.view.frame.height - topDistance
    ))
    
    scrollView.alwaysBounceVertical = true
    scrollView.delegate = self
    scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    view.addSubview(scrollView)
    
    // MARK: - The head of scroll view
    let headView = UIView()
    
    scrollView.addSubview(headView)
    
    headView.snp.makeConstraints { make in
      make.top.width.equalToSuperview()
      make.height.greaterThanOrEqualTo(206.5).priority(750)
    }
    // Cover
    let coverImageView = UIImageView()
    coverImageView.backgroundColor = BCColor.BarTint.white
    if let image = book?.image {
      coverImageView.kf.setImage(with: URL(string: image))
    }

    headView.addSubview(coverImageView)
    
    coverImageView.snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 115, height: 161))
      make.left.equalToSuperview().inset(16)
      make.centerY.equalToSuperview()
    }
    // Title
    let titleLabel = UILabel()
    titleLabel.text = book?.title
    titleLabel.font = UIFont.systemFont(ofSize: 17.0)
    titleLabel.textColor = BCColor.BarTint.white
    titleLabel.numberOfLines = 0

    headView.addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints { make in
      make.left.equalTo(coverImageView.snp.right).offset(14)
      make.right.lessThanOrEqualToSuperview().inset(15)
      make.top.equalToSuperview().inset(16)
    }
    
    var items = [String]()
    
    if let authors = book?.authors, !authors.isEmpty {
      var author = String()
      authors.forEach { author += $0 + " " }
      items.append("Author: \(author)")
    }
    
    if let translators = book?.translators, !translators.isEmpty {
      var translator = String()
      translators.forEach { translator += $0 + " " }
      items.append("Translator: \(translator)")
    }
    
    if book?.publisher != nil { items.append("Publisher: \(book!.publisher!)") }
    
    if book?.publishedDate != nil { items.append("Published Date: \(book!.publishedDate!)") }
    
    if book?.price != nil { items.append("Price: \(book!.price!)") }
    
    if let isbn = book?.isbn13 {
      items.append("ISBN: \(isbn)")
    } else if let isbn = book?.isbn10 {
      items.append("ISBN: \(isbn)")
    }
    // Info text
    let stackView = UIStackView(
      arrangedSubviews: items.map { item in
        let label = UILabel()
        label.text = item
        label.font = UIFont.systemFont(ofSize: 11.0)
        label.textColor = BCColor.BarTint.white
        label.numberOfLines = 0
        
        return label
      }
    )
    stackView.axis = .vertical
    stackView.spacing = 4
    
    headView.addSubview(stackView)
    
    stackView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(4)
      make.left.right.equalTo(titleLabel)
    }
    // Mark button
    let markButton = UIButton(type: .custom)
    markButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
    markButton.backgroundColor = BCColor.BarTint.white
    
    markButton.setTitle("Mark", for: .normal)
    markButton.setTitle("Unmark", for: .disabled)
    markButton.setTitleColor(UIColor(HEX: 0x00A25B), for: .normal)
    markButton.setTitleColor(UIColor(HEX: 0xB8B8B8), for: .disabled)
    markButton.layer.cornerRadius = 2.0
    
    markButton.addTarget(self, action: #selector(mark(_:)), for: .touchUpInside)
    
    headView.addSubview(markButton)
    
    markButton.snp.makeConstraints { make in
      make.left.equalTo(titleLabel)
      make.size.equalTo(CGSize(width: 70, height: 27))
      make.top.equalTo(stackView.snp.bottom).offset(6)
      make.bottom.equalToSuperview().inset(4)
    }
    
    // ImageView layout
    backgroundImageView.snp.makeConstraints { make in
      make.top.centerX.width.equalToSuperview()
      make.height.equalTo(headView).offset(topDistance)
    }

    // MARK: - The body of scroll view
    let bodyView = UIView()
    bodyView.backgroundColor = BCColor.BarTint.white
    
    scrollView.addSubview(bodyView)
    
    bodyView.snp.makeConstraints { make in
      make.width.bottom.equalToSuperview()
      make.top.equalTo(headView.snp.bottom)
    }
    
    // summary
    let summaryLabel = UILabel()
    summaryLabel.text = "Summary"
    summaryLabel.font = UIFont.systemFont(ofSize: 16.0)
    summaryLabel.textColor = UIColor(HEX: 0x555555)
    
    bodyView.addSubview(summaryLabel)
    
    summaryLabel.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview().inset(15)
    }
    
    // content detail
    let detailLabel = UILabel()
    detailLabel.numberOfLines = 0
    detailLabel.font = UIFont.systemFont(ofSize: 15.0)
    detailLabel.textColor = UIColor(HEX: 0x999999)
    
    detailLabel.text = book?.summary
    
    bodyView.addSubview(detailLabel)
    
    detailLabel.snp.makeConstraints { make in
      make.left.right.bottom.equalToSuperview().inset(15)
      make.top.equalTo(summaryLabel.snp.bottom).offset(6.5)
    }
    
    view.layoutIfNeeded()
    backgroundHeight = headView.frame.height + topDistance
  }
}

// MARK: - Actions
extension BCInfoViewController {
  @objc func mark(_ sender: UIButton? = nil) {
    
  }
}

// MARK: - ScrollView Delegate
extension BCInfoViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // Scroll down when content offset y is negative.
    // Fix bug: in iOS 13, view frame is not show when frame has changed.
    // but, it works for view.layer.frame!
    backgroundImageView.layer.frame = CGRect(
      x: 0,
      y: 0,
      width: view.frame.width,
      height: scrollView.contentOffset.y < 0 ?
        backgroundHeight - scrollView.contentOffset.y : backgroundHeight
    )
  }
}
