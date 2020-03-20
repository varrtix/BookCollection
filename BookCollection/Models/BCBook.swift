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
import WCDBSwift

struct BCBook: BCModelORM {
  
  typealias DB = BCBookDB
  
  typealias JSON = BCBookJSON
}

class BCBookJSON: BCModel, BCBookFoundation, Codable {
  
  let doubanID: String?
  
  let title: String?
  
  let subtitle: String?
  
  let originTitle: String?
  
  let publishedDate: String?
  
  let publisher: String?
  
  let isbn10: String?
  
  let isbn13: String?
  
  let image: String?
  
  let binding: String?
  
  let authorIntroduction: String?
  
  let catalog: String?
  
  let pages: String?
  
  let summary: String?
  
  let price: String?
  
  let authors: [String]?
  
  let translators: [String]?
  
  let tags: [BCTag.JSON]?
  
  let images: BCImages.JSON?
  
  let series: BCSeries.JSON?
  
  let rating: BCRating.JSON?
  
  enum CodingKeys: String, CodingKey {
    case doubanID = "id"
    case title, subtitle
    case originTitle = "origin_title"
    case publishedDate = "pubdate"
    case publisher, isbn10, isbn13, image, binding
    case authorIntroduction = "author_intro"
    case catalog, pages, summary, price
    case authors = "author"
    case translators = "translator"
    case tags, images, series, rating
  }
}

class BCBookDB: BCModel, BCBookFoundation, TableCodable {
  
  let id: Int64?
  
  let doubanID: String?
  
  let title: String?
  
  let subtitle: String?
  
  let originTitle: String?
  
  let publishedDate: String?
  
  let publisher: String?
  
  let isbn10: String?
  
  let isbn13: String?
  
  let image: String?
  
  let binding: String?
  
  let authorIntroduction: String?
  
  let catalog: String?
  
  let pages: String?
  
  let summary: String?
  
  let price: String?
  
  enum CodingKeys: String, CodingTableKey {
    typealias Root = BCBookDB
    
    static let objectRelationalMapping = TableBinding(CodingKeys.self)
    
    case id
    case doubanID = "douban_id"
    case title, subtitle
    case originTitle = "origin_title"
    case publishedDate = "pubdate"
    case publisher, isbn10, isbn13, image, binding
    case authorIntroduction = "author_intro"
    case catalog, pages, summary, price
    
    static var columnConstraintBindings:
      [BCBookDB.CodingKeys : ColumnConstraintBinding]? {
      [
        id: ColumnConstraintBinding(
          isPrimary: true,
          isAutoIncrement: true,
          isNotNull: true,
          isUnique: true
        ),
        doubanID: ColumnConstraintBinding(isUnique: true),
      ]
    }
  }
  
  init(
    doubanID: String?,
    title: String?,
    subtitle: String?,
    originTitle: String?,
    publishedDate: String?,
    publisher: String?,
    isbn10: String?,
    isbn13: String?,
    image: String?,
    binding: String?,
    authorIntroduction: String?,
    catalog: String?,
    pages: String?,
    price: String?
  ) {
    self.doubanID = doubanID
    self.title = title
    self.subtitle = subtitle
    self.originTitle = originTitle
    self.publishedDate = publishedDate
    self.publisher = publisher
    self.isbn10 = isbn10
    self.isbn13 = isbn13
    self.image = image
    self.binding = binding
    self.authorIntroduction = authorIntroduction
    self.catalog = catalog
    self.pages = pages
    self.price = price
  }
  
  var isAutoIncrement: Bool = true
  
  var lastInsertedRowID: Int64 = 0
}

extension BCBookJSON {
  var bookDB: BCBookDB? {
    BCBookDB(
      doubanID: doubanID,
      title: title,
      subtitle: subtitle,
      originTitle: originTitle,
      publishedDate: publishedDate,
      publisher: publisher,
      isbn10: isbn10,
      isbn13: isbn13,
      image: image,
      binding: binding,
      authorIntroduction: authorIntroduction,
      catalog: catalog,
      pages: pages,
      price: price
    )
  }
  
  var tagsDB: [BCTagDB]? {
    guard tags != nil else { return nil }
    return tags!.map { BCTagDB(count: $0.count, title: $0.title) }
  }
  
  var imagesDB: BCImagesDB? {
    guard images != nil else { return nil }
    return BCImagesDB(
      small: images!.small,
      medium: images!.medium,
      large: images!.large
    )
  }
  
  var seriesDB: BCSeriesDB? {
    guard series != nil else { return nil }
    return BCSeriesDB(seriesID: series!.seriesID, title: series!.title)
  }
  
  var ratingDB: BCRatingDB? {
    guard rating != nil else { return nil }
    return BCRatingDB(
      max: rating!.max,
      numRaters: rating!.numRaters,
      average: rating!.average,
      min: rating!.min
    )
  }
  
  var authorsDB: [BCAuthorDB]? {
    guard authors != nil else { return nil }
    return authors!.map { BCAuthorDB(name: $0) }
  }
  
  var translatorsDB: [BCTranslatorDB]? {
    guard translators != nil else { return nil }
    return translators!.map { BCTranslatorDB(name: $0) }
  }
}
