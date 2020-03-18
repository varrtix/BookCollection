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

class BCInfoViewController: BCViewController {
  
  fileprivate var backgroundImageView = UIImageView(image: UIImage(named: "Info/NavigationBar"))
  
  var book: BCBook.Coder?
  
  init(with book: BCBook.Coder) {
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
extension BCInfoViewController: UIScrollViewDelegate {
  
  fileprivate func configureNavigation() {
    navigationItem.title = "Book Information"
    
    navigationBarBackgroundImage = UIImage()
    
    shouldShowShadowImage = false
    
    shouldHideBottomBarWhenPushed = true
  }
  // MARK: configure subviews
  fileprivate func configureSubviews() {
    configureBackgroundView()
    
    configureScrollView()
  }
  
  fileprivate func configureBackgroundView() {
    backgroundImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 270.5)
    backgroundImageView.autoresizingMask = .flexibleWidth
    
    view.addSubview(backgroundImageView)
  }
  
  fileprivate func configureScrollView() {
    guard let barHeight = navigationController?.navigationBar.frame.height else { return }
    let scrollView = UIScrollView(frame: CGRect(
      x: 0,
      y: barHeight,
      width: self.view.frame.width,
      height: self.view.frame.height - barHeight
    ))
    
    scrollView.alwaysBounceVertical = true
    scrollView.delegate = self
    scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    view.addSubview(scrollView)
    
    let headView = UIView()
    
    scrollView.addSubview(headView)
    
    scrollView.snp.makeConstraints { make in
      make.top.width.equalToSuperview()
      make.height.equalTo(206.5)
    }
    
    let cover = UIImageView()
    cover.backgroundColor = BCColor.BarTint.white
    
    headView.addSubview(cover)
    
    cover.snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 115, height: 161))
      make.top.left.equalTo(16)
    }
    
    let titleLabel = UILabel()
    titleLabel.text = book?.title
    titleLabel.font = UIFont.systemFont(ofSize: 17.0)
    titleLabel.textColor = BCColor.BarTint.white
    
    headView.addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints { make in
      make.left.equalTo(cover.snp.right).inset(14)
      make.right.greaterThanOrEqualToSuperview().inset(15)
    }
  }
}
