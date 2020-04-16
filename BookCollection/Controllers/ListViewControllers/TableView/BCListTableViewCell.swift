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

class BCListTableViewCell: BCTableViewCell {
  
  fileprivate lazy var coverImageView = UIImageView()
  
  fileprivate lazy var authorLabel = UILabel()
  
  fileprivate lazy var titleLabel = UILabel()
  
  fileprivate lazy var tagsView = UIView()
  
  var cover: UIImage? { coverImageView.image }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    launchSubviews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() { super.awakeFromNib() }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}

// MARK: - Subviews
extension BCListTableViewCell {
  fileprivate func launchSubviews() {
    contentView.backgroundColor = BCColor.ListTint.snowWhite
    
    coverImageView.backgroundColor = .white
    contentView.addSubview(coverImageView)
    
    authorLabel.font = UIFont.systemFont(ofSize: 13)
    authorLabel.textColor = UIColor(HEX: 0x999999)
    contentView.addSubview(authorLabel)
    
    titleLabel.font = UIFont.systemFont(ofSize: 16)
    titleLabel.textColor = UIColor(HEX: 0x555555)
    contentView.addSubview(titleLabel)
    
    contentView.addSubview(tagsView)
    
    coverImageView.snp.makeConstraints { make in
      make.left.top.equalToSuperview().inset(15)
      make.size.equalTo(CGSize(width: 50, height: 70))
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(coverImageView)
      make.left.equalTo(coverImageView.snp.right).offset(15)
      make.right.lessThanOrEqualToSuperview().inset(15)
    }
    
    authorLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(6)
      make.left.equalTo(titleLabel)
      make.right.lessThanOrEqualToSuperview().inset(15)
    }
    
    tagsView.snp.makeConstraints { make in
      make.left.equalTo(titleLabel)
      make.right.lessThanOrEqualToSuperview().inset(15)
      make.top.equalTo(authorLabel.snp.bottom).offset(10)
      make.height.equalTo(18)
    }
  }
  
  override func prepareForReuse() {
    titleLabel.text = nil
    coverImageView.image = nil
    authorLabel.text = nil
    
    tagsView.subviews.forEach { $0.removeFromSuperview() }
  }
}

// MARK: - Configure data
extension BCListTableViewCell {
  func inject(book: BCBook) {
    titleLabel.text = book.title
    
    if let authors = book.authors, !authors.isEmpty {
      var author = "Author: "
      authors.forEach { author += $0 + " " }
      authorLabel.text = author
    }
    
    if let tags = book.tags {
      let stackView = UIStackView(
        arrangedSubviews: tags[0...min(tags.count, 3)].map { item -> UIButton in
          let button = UIButton(type: .custom)
          button.setTitleColor(UIColor(HEX: 0x999999), for: .normal)
          button.titleLabel?.font = UIFont.systemFont(ofSize: 9)
          button.layer.cornerRadius = 2.0
          button.layer.borderColor = UIColor(HEX: 0x999999).cgColor
          button.layer.borderWidth = 0.5
          button.contentEdgeInsets = UIEdgeInsets(top: 3.0, left: 5.0, bottom: 3.0, right: 5.0)
          button.setTitle(item.title, for: .normal)
          button.sizeToFit()
          
          return button
      })
      
      stackView.axis = .horizontal
      stackView.spacing = 8
      tagsView.addSubview(stackView)
      
      stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
      
    }
  }
  
  func loadingImage(with path: String?) {
    guard path != nil else { return }
    coverImageView.kf.setImage(with: URL(string: path!))
  }
  
  func cancelLoadingImage() {
    coverImageView.kf.cancelDownloadTask()
  }
}
