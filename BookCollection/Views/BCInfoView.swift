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

protocol BCInfoViewDelegate: UIScrollViewDelegate {
  var titleText: String { get }
  
  var detailTexts: [String] { get }
  
  var summaryText: String { get }
  
  var isMarked: Bool { get }
  
  func coverImageViewDidLoad(_ cover: UIImageView)
  
  func didFinishingMark(by button: UIButton?) -> Bool
}

final class BCInfoView: UIView {
  
  var delegate: BCInfoViewDelegate?
  
  private(set) var backgroundImageView = UIImageView(image: UIImage(named: "Info/NavigationBar"))
  
  private(set) var backgroundHeight: CGFloat = 270.5
  
  private let scrollViewOffset: CGFloat
  
  private let markButton = UIButton(type: .custom)
  
  init(frame: CGRect, withScrollView offset: CGFloat) {
    scrollViewOffset = offset
    
    super.init(frame: frame)
    
    createSubviews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func createSubviews() {
    addSubview(backgroundImageView)
    
    createScrollView()
  }
  
  func createScrollView() {
    // MARK: Scroll view
    let scrollView = UIScrollView(frame: CGRect(
      x: 0,
      y: scrollViewOffset,
      width: frame.width,
      height: frame.height - scrollViewOffset
    ))
    
    scrollView.alwaysBounceVertical = true
    scrollView.delegate = delegate
    scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    addSubview(scrollView)
    
    // MARK: The head of scroll view
    let headView = UIView()
    
    scrollView.addSubview(headView)
    
    headView.snp.makeConstraints { make in
      make.top.width.equalToSuperview()
      make.height.greaterThanOrEqualTo(206.5).priority(750)
    }
    // Cover
    let coverImageView = UIImageView()
    coverImageView.backgroundColor = BCColor.BarTint.white
    delegate?.coverImageViewDidLoad(coverImageView)
    
    headView.addSubview(coverImageView)
    
    coverImageView.snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 115, height: 161))
      make.left.equalToSuperview().inset(16)
      make.centerY.equalToSuperview()
    }
    // Title
    let titleLabel = UILabel()
    titleLabel.text = delegate?.titleText
    titleLabel.font = UIFont.systemFont(ofSize: 17.0)
    titleLabel.textColor = BCColor.BarTint.white
    titleLabel.numberOfLines = 0
    
    headView.addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints { make in
      make.left.equalTo(coverImageView.snp.right).offset(14)
      make.right.lessThanOrEqualToSuperview().inset(15)
      make.top.equalToSuperview().inset(16)
    }
    
    // Info text
    let stackView = UIStackView(
      //      arrangedSubviews: items.map { item in
      arrangedSubviews: delegate?.detailTexts.map { item in
        let label = UILabel()
        label.text = item
        label.font = UIFont.systemFont(ofSize: 11.0)
        label.textColor = BCColor.BarTint.white
        label.numberOfLines = 0
        
        return label
        } ?? [UIView()]
    )
    
    stackView.axis = .vertical
    stackView.spacing = 4
    
    headView.addSubview(stackView)
    
    stackView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(4)
      make.left.right.equalTo(titleLabel)
    }
    
    // Mark button
    markButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
    markButton.backgroundColor = BCColor.BarTint.white
    
    markButton.setTitle("Mark", for: .normal)
    markButton.setTitle("Unmark", for: .selected)
    markButton.setTitleColor(UIColor(HEX: 0x00A25B), for: .normal)
    markButton.setTitleColor(UIColor(HEX: 0xB8B8B8), for: .selected)
    markButton.layer.cornerRadius = 2.0
    
    markButton.addTarget(self, action: #selector(mark(_:)), for: .touchUpInside)
    
    headView.addSubview(markButton)
    
    markButton.snp.makeConstraints { make in
      make.left.equalTo(titleLabel)
      make.size.equalTo(CGSize(width: 70, height: 27))
      make.top.equalTo(stackView.snp.bottom).offset(6)
      make.bottom.equalToSuperview().inset(4)
    }
    
    //    markButton.isSelected = isMarked
    markButton.isSelected = delegate?.isMarked ?? false
    
    // ImageView layout
    backgroundImageView.snp.makeConstraints { make in
      make.top.centerX.width.equalToSuperview()
      make.height.equalTo(headView).offset(scrollViewOffset)
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
    
    //    detailLabel.text = book?.summary
    detailLabel.text = delegate?.summaryText
    
    bodyView.addSubview(detailLabel)
    
    detailLabel.snp.makeConstraints { make in
      make.left.right.bottom.equalToSuperview().inset(15)
      make.top.equalTo(summaryLabel.snp.bottom).offset(6.5)
    }
    
    layoutIfNeeded()
    backgroundHeight = headView.frame.height + scrollViewOffset
  }
}

@objc
extension BCInfoView {
  func mark(_ sender: UIButton? = nil) {
    markButton.isSelected = delegate?.didFinishingMark(by: sender) ?? false
  }
}
//extension BCInfoView: UIScrollViewDelegate {
//  func scrollViewDidScroll(_ scrollView: UIScrollView) {
//    backgroundImageView.layer.frame = CGRect(
//      x: 0,
//      y: 0,
//      width: view.frame.width,
//      height: scrollView.contentOffset.y < 0 ?
//        backgroundHeight - scrollView.contentOffset.y : backgroundHeight
//    )
//  }
//}
