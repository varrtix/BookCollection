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

class BCDatabaseOperation: AsyncOperation {
  
  static var databaseDirectoryURL: URL {
    URL(
      fileURLWithPath: "BCDB",
      relativeTo: FileManager.documentDirectoryURL)
  }
  
  static var databaseURL: URL {
    URL(
      fileURLWithPath: "Book.sqlite",
      relativeTo: databaseDirectoryURL)
  }
  
  override func main() {
    if !FileManager.default.fileExists(
      atPath: BCDatabaseOperation
        .databaseDirectoryURL
        .absoluteString) {
      do {
        try FileManager.default.createDirectory(
          at: BCDatabaseOperation.databaseDirectoryURL,
          withIntermediateDirectories: true)
      } catch {
        print("Create DB Directory error: \(error)")
      }
    }
    
    let database = Database(withFileURL: BCDatabaseOperation.databaseURL)
    
    guard database.isOpened else { return }
    
    do {
      try createTable(with: database)
    } catch {
      print("create DB error: \(error)")
    }
  }
}

extension BCDatabaseOperation {
  func createTable(with database: Database) throws {
    defer { if database.isOpened { database.close() } }
   
    do {
      try database.create(table: "TB_BC_ROOT_BOOK", of: BCBook.DB.self)
      try database.create(table: "TB_BC_AUTHORS", of: BCAuthor.DB.self)
      try database.create(table: "TB_BC_TRANSLATORS", of: BCTranslator.DB.self)
      try database.create(table: "TB_BC_TAGS", of: BCTag.DB.self)
      try database.create(table: "TB_BC_IMAGES", of: BCImages.DB.self)
      try database.create(table: "TB_BC_SERIES", of: BCSeries.DB.self)
      try database.create(table: "TB_BC_RATINGS", of: BCRating.DB.self)
      
    } catch { throw error }
    
  }
}
