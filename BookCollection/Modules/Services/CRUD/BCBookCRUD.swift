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
import SQLite

final class BCBookCRUD: PrimaryKeyCRUD {
  
  typealias Object = BCBook
  
  @discardableResult
  class func insert(_ object: BCBook) throws -> Int64 {
    let id = try DB.connection?.run(BCTableKind.book.table.insert(
      TBBook.doubanID <- object.doubanID,
      TBBook.title <- object.title,
      TBBook.subtitle <- object.subtitle,
      TBBook.originTitle <- object.originTitle,
      TBBook.publishedDate <- object.publishedDate,
      TBBook.publisher <- object.publisher,
      TBBook.isbn10 <- object.isbn10,
      TBBook.isbn13 <- object.isbn13,
      TBBook.image <- object.image,
      TBBook.binding <- object.binding,
      TBBook.authorIntroduction <- object.authorIntroduction,
      TBBook.catalog <- object.catalog,
      TBBook.pages <- object.pages,
      TBBook.summary <- object.summary,
      TBBook.price <- object.price
    )) ?? -1
    
    guard id > 0 else { return id }
    
    if let tags = object.tags {
      try BCTagsCRUD.insert(tags, by: id)
    }
    
    if let images = object.images {
      try BCImagesCRUD.insert(images, by: id)
    }
    
    if let series = object.series {
      try BCSeriesCRUD.insert(series, by: id)
    }
    
    if let rating = object.rating {
      try BCRatingCRUD.insert(rating, by: id)
    }
    
    if let authors = object.authors {
      try BCAuthorsCRUD.insert(authors, by: id)
    }
    
    if let translators = object.translators {
      try BCTranslatorsCRUD.insert(translators, by: id)
    }
    
    return id
  }
  
  @discardableResult
  class func get(by key: String) throws -> BCBook? {
    try DB.connection?.pluck(
      BCTableKind.book.table
        .filter(key == (key.count == 10 ? TBBook.isbn10 : TBBook.isbn13)))
      .map { try BCBook(result: $0) }
  }
  
  @discardableResult
  class func multiGet(limit: BCLimit? = nil) throws -> [BCBook]? {
    let table = BCTableKind.book.table
    if let offset = limit?.offset, let length = limit?.length {
      _ = table.limit(length, offset: offset)
    } else {
      _ = table.limit(limit?.length)
    }
    return try DB.connection?
      .prepare(table)
      .map { try BCBook(result: $0) }
  }
  
  @discardableResult
  class func delete(by key: String) throws -> Int {
    try DB.connection?.run(
      BCTableKind.book.table
        .filter(key == TBBook.doubanID).delete()) ?? -1
  }

  @discardableResult
  class func count() throws -> Int {
    try DB.connection?.scalar(BCTableKind.book.table.count) ?? -1
  }
}

fileprivate extension BCBook {
  convenience init(result: Row) throws {
    let id = result[TBBook.id]
    self.init(
      isMarked: true,
      doubanID: result[TBBook.doubanID],
      title: result[TBBook.title],
      subtitle: result[TBBook.subtitle],
      originTitle: result[TBBook.originTitle],
      publishedDate: result[TBBook.publishedDate],
      publisher: result[TBBook.publisher],
      isbn10: result[TBBook.isbn10],
      isbn13: result[TBBook.isbn13],
      image: result[TBBook.image],
      binding: result[TBBook.binding],
      authorIntroduction: result[TBBook.authorIntroduction],
      catalog: result[TBBook.catalog],
      pages: result[TBBook.pages],
      summary: result[TBBook.summary],
      price: result[TBBook.price],
      authors: try BCAuthorsCRUD.get(by: id),
      translators: try BCTranslatorsCRUD.get(by: id),
      tags: try BCTagsCRUD.get(by: id),
      images: try BCImagesCRUD.get(by: id),
      series: try BCSeriesCRUD.get(by: id),
      rating: try BCRatingCRUD.get(by: id)
    )
  }
}
