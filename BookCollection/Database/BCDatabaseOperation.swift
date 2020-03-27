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
    BCDB.check().AsyncConnect { self.createTables(with: $0) }
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
      try connection
        .run(BCTagsTable.create(ifNotExists: true) {
          $0.column(BCTagDBD.bookID)
          $0.column(BCTagDBD.count)
          $0.column(BCTagDBD.title)
          $0.foreignKey(
            BCTagDBD.bookID,
            references: BCBookTable, BCBookDBD.id,
            delete: .cascade
          )
        })
      // MARK: Table images
      try connection
        .run(BCImagesTable.create(ifNotExists: true) {
          $0.column(BCImagesDBD.bookID)
          $0.column(BCImagesDBD.small)
          $0.column(BCImagesDBD.medium)
          $0.column(BCImagesDBD.large)
          $0.foreignKey(
            BCImagesDBD.bookID,
            references: BCBookTable, BCBookDBD.id,
            delete: .cascade
          )
        })
      // MARK: Table series
      try connection
        .run(BCSeriesTable.create(ifNotExists: true) {
          $0.column(BCSeriesDBD.bookID)
          $0.column(BCSeriesDBD.seriesID)
          $0.column(BCSeriesDBD.title)
          $0.foreignKey(
            BCSeriesDBD.bookID,
            references: BCBookTable, BCBookDBD.id,
            delete: .cascade
          )
        })
      // MARK: Table rating
      try connection
        .run(BCRatingTable.create(ifNotExists: true) {
          $0.column(BCRatingDBD.bookID)
          $0.column(BCRatingDBD.max)
          $0.column(BCRatingDBD.numRaters)
          $0.column(BCRatingDBD.min)
          $0.column(BCRatingDBD.average)
          $0.foreignKey(
            BCRatingDBD.bookID,
            references: BCBookTable, BCBookDBD.id,
            delete: .cascade
          )
        })
      // MARK: Table authors
      try connection
        .run(BCAuthorsTable.create(ifNotExists: true) {
          $0.column(BCAuthorDBD.bookID)
          $0.column(BCAuthorDBD.name)
          $0.foreignKey(
            BCAuthorDBD.bookID,
            references: BCBookTable, BCBookDBD.id,
            delete: .cascade
          )
        })
      // MARK: Table translators
      try connection
        .run(BCTranslatorsTable.create(ifNotExists: true) {
          $0.column(BCTranslatorDBD.bookID)
          $0.column(BCTranslatorDBD.name)
          $0.foreignKey(
            BCTranslatorDBD.bookID,
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
  @available(*, deprecated, message: "Up to BCDatabase")
  fileprivate func connect(
    _ url: URL, completionHandler: @escaping (BCResult<Connection>
    ) -> Void) {
    
    let result = BCResult<Connection> {
      if !FileManager.default.fileExists(
        atPath: BCDatabase
          .directoryURL
          .absoluteString) {
        try FileManager.default.createDirectory(
          at: BCDatabase.directoryURL,
          withIntermediateDirectories: true)
      }
      return try Connection(url)
    }
    completionHandler(result)
  }
}

extension Connection {
  convenience init(_ url: URL, readonly: Bool = false) throws {
    try self.init(url.absoluteString, readonly: readonly)
  }
}
