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
//import WCDBSwift
import SQLite

//struct BCSeries: BCORMAlias {
//
//  typealias DB = BCSeriesDB
//
//  typealias JSON = BCSeriesJSON
//}

//class BCSeriesJSON: BCModel, BCJSONCodable, BCSeriesFoundation {
//
//  typealias DBType = BCSeries.DB
struct BCSeries: BCCodable {
  
  let seriesID: String?
  
  let title: String?
  
  enum CodingKeys: String, CodingKey {
    case seriesID = "id"
    case title
  }
  
//  init(seriesID: String?, title: String?) {
//    self.seriesID = seriesID
//    self.title = title
//  }
//
//  var dbFormat: BCSeries.DB { BCSeries.DB(seriesID: seriesID, title: title) }
}

//class BCSeriesDB: BCModel, BCDBCodable, BCSeriesFoundation {
  
//  typealias JSONType = BCSeries.JSON
struct BCSeriesDB: BCDBModel {
  
//  var bookID: Int64?
  let bookID = Expression<Int64>("book_id")
  
  let seriesID = Expression<String?>(BCSeries.CodingKeys.seriesID.rawValue)
  
  let title = Expression<String?>(BCSeries.CodingKeys.title.rawValue)
}
//
//  enum CodingKeys: String, CodingTableKey {
//    typealias Root = BCSeriesDB
//
//    static let objectRelationalMapping = TableBinding(CodingKeys.self)
//
//    case bookID = "book_id"
//    case seriesID = "series_id"
//    case title
//
//    static var tableConstraintBindings: [String : TableConstraintBinding]? {
//      let foreginBinding = ForeignKeyBinding(bookID, foreignKey: BCBook.DB.foreginKey)
//      return ["ForeignKeyBinding": foreginBinding]
//    }
//  }
//
//  init(seriesID: String?, title: String?) {
//    self.seriesID = seriesID
//    self.title = title
//  }
//
//  var jsonFormat: BCSeries.JSON { BCSeries.JSON(seriesID: seriesID, title: title) }
//}
