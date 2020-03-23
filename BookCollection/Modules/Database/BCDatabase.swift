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

import Foundation

struct BCDatabase {
  static var directoryURL: URL {
    URL(
      fileURLWithPath: "BCDB",
      relativeTo: FileManager.documentDirectoryURL)
  }
  
  static var fileURL: URL {
    URL(
      fileURLWithPath: "Book.sqlite",
      relativeTo: directoryURL)
  }
  
  static let queue = DispatchQueue(
    label: "com.varrtix.bcdatabase",
    qos: .background,
    attributes: .concurrent)
}

struct BCTable {
  
  enum Kind: String, CaseIterable {
    case book, authors, translators
    case tags, images, series, rating
    
    var rawName: String { "TB_BC_\(self.rawValue.uppercased())" }
  }
  
  fileprivate var root: BCBook.JSON
  
  var book: BCBook.DB {
    return BCBookDB(
      doubanID: root.doubanID,
      title: root.title,
      subtitle: root.subtitle,
      originTitle: root.originTitle,
      publishedDate: root.publishedDate,
      publisher: root.publisher,
      isbn10: root.isbn10,
      isbn13: root.isbn13,
      image: root.image,
      binding: root.binding,
      authorIntroduction: root.authorIntroduction,
      catalog: root.catalog,
      pages: root.pages,
      summary: root.summary,
      price: root.price
    )
  }
  
  var tags: [BCTag.DB]? { root.tags == nil ? nil : root.tags!.map { $0.dbFormat } }
  
  var images: BCImages.DB? { root.images == nil ? nil : root.images!.dbFormat }
  
  var series: BCSeries.DB? { root.series == nil ? nil : root.series!.dbFormat }
  
  var rating: BCRating.DB? { return root.rating == nil ? nil : root.rating!.dbFormat }
  
  var authors: [BCAuthor.DB]? { root.authors == nil ? nil : root.authors!.map { BCAuthor.DB(name: $0) } }
  
  var translators: [BCTranslator.DB]? { root.translators == nil ? nil : root.translators!.map { BCTranslator.DB(name: $0) } }
  
  init(root: BCBook.JSON) { self.root = root }
}
