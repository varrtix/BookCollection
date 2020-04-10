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
    try DB.connection?.run(BCTableKind.book.table.insert(
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
  }
  
  //final class BCBookCRUD {
  //  static func insert(or conflict: OnConflict, _ object: Codable, into table: Table, setters: Setter...) throws -> Int64 {
  //    try DB.connection?.run(table.insert(setters)) ?? -1
  //  }
  //
  //
  //}
  
  //  class func insert(_ object: BCBook) throws -> Int64 {
  //    let id = try DB.connection?.run(TableKind.book.table.insert(
  //      TBBook.doubanID <- book.doubanID,
  //      TBBook.title <- book.title,
  //      TBBook.subtitle <- book.subtitle,
  //      TBBook.originTitle <- book.originTitle,
  //      TBBook.publishedDate <- book.publishedDate,
  //      TBBook.publisher <- book.publisher,
  //      TBBook.isbn10 <- book.isbn10,
  //      TBBook.isbn13 <- book.isbn13,
  //      TBBook.image <- book.image,
  //      TBBook.binding <- book.binding,
  //      TBBook.authorIntroduction <- book.authorIntroduction,
  //      TBBook.catalog <- book.catalog,
  //      TBBook.pages <- book.pages,
  //      TBBook.summary <- book.summary,
  //      TBBook.price <- book.price
  //    ))
  //
  //    return id ?? -1
  //  }
}
