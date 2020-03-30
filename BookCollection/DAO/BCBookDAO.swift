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

struct BCBookDAO {
  
  @discardableResult
  static func insert(
    or conflict: SQLite.OnConflict,
    _ book: BCBook,
    with connection: Connection
  ) throws -> Int64 {
    let id = try connection.run(BCBookTable.insert(
      or: conflict,
      BCBookDBD.doubanID <- book.doubanID,
      BCBookDBD.title <- book.title,
      BCBookDBD.subtitle <- book.subtitle,
      BCBookDBD.originTitle <- book.originTitle,
      BCBookDBD.publishedDate <- book.publishedDate,
      BCBookDBD.publisher <- book.publisher,
      BCBookDBD.isbn10 <- book.isbn10,
      BCBookDBD.isbn13 <- book.isbn13,
      BCBookDBD.image <- book.image,
      BCBookDBD.binding <- book.binding,
      BCBookDBD.authorIntroduction <- book.authorIntroduction,
      BCBookDBD.catalog <- book.catalog,
      BCBookDBD.pages <- book.pages,
      BCBookDBD.summary <- book.summary,
      BCBookDBD.price <- book.price
    ))
    
    if book.tags != nil {
      try book.tags!.forEach {
        try BCTagDAO.insert(or: .ignore, $0, by: id, with: connection)
      }
    }
    //    } else { throw V2RXError.DataAccessObjects.invalidData }
    
    if book.images != nil {
      try BCImagesDAO.insert(or: .ignore, book.images!, by: id, with: connection)
    }
    //    } else { throw V2RXError.DataAccessObjects.invalidData }
    
    if book.series != nil {
      try BCSeriesDAO.insert(or: .ignore, book.series!, by: id, with: connection)
    }
    //    else { throw V2RXError.DataAccessObjects.invalidData }
    
    if book.rating != nil {
      try BCRatingDAO.insert(or: .ignore, book.rating!, by: id, with: connection)
    }
    //    else { throw V2RXError.DataAccessObjects.invalidData }
    
    if book.authors != nil {
      try book.authors!.forEach {
        try BCAuthorDAO.insert(or: .ignore, $0, by: id, with: connection)
      }
    }
    //    else { throw V2RXError.DataAccessObjects.invalidData }
    
    if book.translators != nil {
      try book.translators!.forEach {
        try BCTranslatorDAO.insert(or: .ignore, $0, by: id, with: connection)
      }
    }
    //    else { throw V2RXError.DataAccessObjects.invalidData }
    
    return id
  }
  
  static func query(
    by isbn: String,
    with connection: Connection
  ) throws -> BCBook? {
    guard let book = try connection
      .pluck(BCBookTable.filter(isbn == (isbn.count == 10 ? BCBookDBD.isbn10 : BCBookDBD.isbn13)))
      else { return nil }
    
    return try BCBook(book: book, with: connection)
  }
  
  static func queryAll(
    offset: Int,
    size: Int,
    with connection: Connection
  ) throws -> [BCBook] {
    let books = try connection.prepare(BCBookTable.limit(size, offset: offset))
    
    return try books.map { try BCBook(book: $0, with: connection) }
  }
  
  static func delete(
    by doubanID: String,
    with connection: Connection
  ) throws -> Int {
    return try connection.run(BCBookTable.filter(doubanID == BCBookDBD.doubanID).delete())
  }
}


fileprivate extension BCBook {
  init(book: Row, with connection: Connection) throws {
    let id = book[BCBookDBD.id]
    self.init(
      book: book,
      images: try BCImagesDAO.query(by: id, with: connection),
      series: try BCSeriesDAO.query(by: id, with: connection),
      rating: try BCRatingDAO.query(by: id, with: connection),
      tags: try BCTagDAO.query(by: id, with: connection),
      authors: try BCAuthorDAO.query(by: id, with: connection),
      translators: try BCTranslatorDAO.query(by: id, with: connection)
    )
  }
}
