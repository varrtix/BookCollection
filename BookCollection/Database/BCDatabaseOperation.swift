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

class BCDatabaseOperation: AsyncOperation {
  
  override func main() {
    connect(BCDatabase.fileURL) {
      BCDBResult.handle($0, success: { connection in
        self.createTables(with: connection)
      }) { V2RXError.printError($0) }
    }
  }
}

extension BCDatabaseOperation {
  
  /// Create tables in connected database.
  /// - Parameter database: The location of tables.
  fileprivate func createTables(with connection: Connection) {
    do {
      // MARK: Table book
      try connection.run(BCBookTable.create(ifNotExists: true) {
            $0.column(BCBookDBD.id, primaryKey: .autoincrement)
            $0.column(BCBookDBD.doubanID, unique: true)
            $0.column(BCBookDBD.title)
            $0.column(BCBookDBD.subtitle)
            $0.column(BCBookDBD.originTitle)
            $0.column(BCBookDBD.publishedDate)
            $0.column(BCBookDBD.publisher)
            $0.column(BCBookDBD.isbn10)
            $0.column(BCBookDBD.isbn13)
            $0.column(BCBookDBD.image)
            $0.column(BCBookDBD.binding)
            $0.column(BCBookDBD.authorIntroduction)
            $0.column(BCBookDBD.catalog)
            $0.column(BCBookDBD.pages)
            $0.column(BCBookDBD.summary)
            $0.column(BCBookDBD.price)
        })
      // MARK: Table tags
      let tag = BCTagDB()
      try connection
        .run(BCDBTable.list[BCDBTable.Kind.tags]!
          .create(ifNotExists: true) {
            $0.column(tag.bookID)
            $0.column(tag.count)
            $0.column(tag.title)
            $0.foreignKey(
              tag.bookID,
              references: BCBookTable, BCBookDBD.id,
              delete: .cascade
            )
        })
      // MARK: Table images
      let images = BCImagesDB()
      try connection
        .run(BCDBTable.list[BCDBTable.Kind.images]!
          .create(ifNotExists: true) {
            $0.column(images.bookID)
            $0.column(images.small)
            $0.column(images.medium)
            $0.column(images.large)
            $0.foreignKey(
              tag.bookID,
              references: BCBookTable, BCBookDBD.id,
              delete: .cascade
            )
        })
      // MARK: Table series
      let series = BCSeriesDB()
      try connection
        .run(BCDBTable.list[BCDBTable.Kind.series]!
          .create(ifNotExists: true) {
            $0.column(series.bookID)
            $0.column(series.seriesID)
            $0.column(series.title)
            $0.foreignKey(
              tag.bookID,
              references: BCBookTable, BCBookDBD.id,
              delete: .cascade
            )
        })
      // MARK: Table rating
      let rating = BCRatingDB()
      try connection
        .run(BCDBTable.list[BCDBTable.Kind.rating]!
          .create(ifNotExists: true) {
            $0.column(rating.bookID)
            $0.column(rating.max)
            $0.column(rating.numRaters)
            $0.column(rating.min)
            $0.column(rating.average)
            $0.foreignKey(
              tag.bookID,
              references: BCBookTable, BCBookDBD.id,
              delete: .cascade
            )
        })
      // MARK: Table authors
      let authors = BCAuthorDB()
      try connection
        .run(BCDBTable.list[BCDBTable.Kind.authors]!
          .create(ifNotExists: true) {
            $0.column(authors.bookID)
            $0.column(authors.name)
            $0.foreignKey(
              tag.bookID,
              references: BCBookTable, BCBookDBD.id,
              delete: .cascade
            )
        })
      // MARK: Table translators
      let translators = BCTranslatorDB()
      try connection
        .run(BCDBTable.list[BCDBTable.Kind.translators]!
          .create(ifNotExists: true) {
            $0.column(translators.bookID)
            $0.column(translators.name)
            $0.foreignKey(
              tag.bookID,
              references: BCBookTable, BCBookDBD.id,
              delete: .cascade
            )
        })
    } catch { V2RXError.printError(error) }
  }
  
  /// Connect SQLite to the database file if it does not already exist, include its parent directories.
  /// - Parameters:
  ///   - url: The location of the database.
  ///   - completionHandler: A closure to be excuted once the connection has finished.
  fileprivate func connect(
    _ url: URL, completionHandler: @escaping (BCResult<Connection>
    ) -> Void) {
    
    let result = BCResult<Connection> {
      if !FileManager.default.fileExists(
        atPath: BCDatabase
          .directoryURL
          .absoluteString) {
        //        do {
        try FileManager.default.createDirectory(
          at: BCDatabase.directoryURL,
          withIntermediateDirectories: true)
        //        } catch { throw error }
      }
      //      do {
      return try Connection(url)
      //      } catch { throw error }
    }
    completionHandler(result)
  }
}

extension Connection {
  convenience init(_ url: URL, readonly: Bool = false) throws {
    try self.init(url.absoluteString, readonly: readonly)
  }
}
