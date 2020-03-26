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

struct BCBookDAO: BCDAO {
  typealias Model = BCBook
  
  @discardableResult
  static func insert(
    or conflict: SQLite.OnConflict,
    _ model: BCBook,
    with connection: Connection
  ) throws -> Int64 {
    return try connection.run(BCBookTable.insert(
      or: conflict,
      BCBookDBD.doubanID <- model.doubanID,
      BCBookDBD.title <- model.title,
      BCBookDBD.subtitle <- model.subtitle,
      BCBookDBD.originTitle <- model.originTitle,
      BCBookDBD.publishedDate <- model.publishedDate,
      BCBookDBD.publisher <- model.publisher,
      BCBookDBD.isbn10 <- model.isbn10,
      BCBookDBD.isbn13 <- model.isbn13,
      BCBookDBD.image <- model.image,
      BCBookDBD.binding <- model.binding,
      BCBookDBD.authorIntroduction <- model.authorIntroduction,
      BCBookDBD.catalog <- model.catalog,
      BCBookDBD.pages <- model.pages,
      BCBookDBD.summary <- model.summary,
      BCBookDBD.price <- model.price
    ))
  }
  
  static func query(
    by doubanID: String,
    with connection: Connection
  ) throws -> BCBook? {
    guard let book = try connection
      .pluck(BCBookTable.filter(doubanID == BCBookDBD.doubanID))
      else { return nil }
    
    let id = book[BCBookDBD.id]
    
    return BCBook(
      book: book,
      images: try BCImagesDAO.query(by: id, with: connection),
      series: try BCSeriesDAO.query(by: id, with: connection),
      rating: try BCRatingDAO.query(by: id, with: connection),
      authors: try BCAuthorDAO.query(by: id, with: connection),
      translators: try BCTranslatorDAO.query(by: id, with: connection)
    )
  }
}
