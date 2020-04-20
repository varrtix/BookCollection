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

protocol BCListCollectionViewCellDataSource {
  func removeCell(_ cell: BCListCollectionViewCell)
}

final class BCListCollectionViewCell: BCCollectionViewCell {
  
  private let coverImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .white
    
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = UIColor(HEX: 0x555555)
    label.numberOfLines = 0
    
    return label
  }()
  
  private let deleteButton: UIButton = {
    let button = UIButton()
    
    button.setImage(UIImage(named: "Main/List/delete"), for: .normal)
    button.isHidden = true
    
    return button
  }()
  
  var isEditing = false {
    didSet {
      DispatchQueue.main.async {
        UIView.animate(
          withDuration: 1,
          delay: 0.2,
          options: .curveEaseInOut,
          animations: { self.deleteButton.isHidden = oldValue }
        )
      }
    }
  }
  
  var cover: UIImage? { coverImageView.image }
  
  var dataSource: BCListCollectionViewCellDataSource?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup(contentView)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Subviews
extension BCListCollectionViewCell {
  private func setup(_ contentView: UIView) {
    contentView.backgroundColor = .clear
    
    contentView.addSubview(coverImageView)

    contentView.addSubview(titleLabel)
    
    contentView.addSubview(deleteButton)
    
    layoutAllViews()
    actionsBinding()
  }
   
  private func layoutAllViews() {
    coverImageView.snp.makeConstraints { make in
      make.left.right.top.equalToSuperview().inset(10)
      make.height.equalTo(coverImageView.snp.width).multipliedBy(7.0/5.0)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(coverImageView.snp.bottom).offset(10)
      make.left.right.equalToSuperview()
    }
    
    deleteButton.snp.makeConstraints { make in
      make.right.top.equalToSuperview()
    }
  }
  
  private func actionsBinding() {
    deleteButton.addTarget(self, action: #selector(remove(_:)), for: .touchUpInside)
  }
  
  override func prepareForReuse() {
    coverImageView.image = nil
    titleLabel.text = nil
  }
}

// MARK: - Inject data
extension BCListCollectionViewCell {
  func inject(book: BCBook) {
    titleLabel.text = book.title
  }
  
  func loadingImage(with url: URL) { coverImageView.kf.setImage(with: url) }
  
  func cancelLoadingImage() { coverImageView.kf.cancelDownloadTask() }
}

// MARK: - Actions
extension BCListCollectionViewCell {
  @objc
  private func remove(_ sender: UIButton? = nil) {
    dataSource?.removeCell(self)
  }
}
