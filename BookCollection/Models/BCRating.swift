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

//struct BCRating: BCORMAlias {
//
//  typealias DB = BCRatingDB
//
//  typealias JSON = BCRatingJSON
//}

//class BCRatingJSON: BCModel, BCJSONCodable, BCRatingFoundation {
  
//  typealias DBType = BCRating.DB
struct BCRating: BCCodable {

  let max: Int?
  
  let numRaters: Int?
  
  let average: String?
  
  let min: Int?
  
  enum CodingKeys: String, CodingKey {
    case max, numRaters, average, min
  }
}
//
//  init(max: Int?, numRaters: Int?, average: String?, min: Int?) {
//    self.max = max
//    self.numRaters = numRaters
//    self.average = average
//    self.min = min
//  }
//
//  var dbFormat: BCRating.DB {
//    BCRating.DB(max: max, numRaters: numRaters, average: average, min: min)
//  }
//}

//class BCRatingDB: BCModel, BCDBCodable, BCRatingFoundation {
  
//  typealias JSONType = BCRating.JSON

struct BCRatingDB: BCDBModel {

//  var bookID: Int64?
  let bookID = Expression<Int64>("book_id")
  
  let max = Expression<Int?>(BCRating.CodingKeys.max.rawValue)
  
  let numRaters = Expression<Int?>(BCRating.CodingKeys.numRaters.rawValue)
  
  let average = Expression<String?>(BCRating.CodingKeys.average.rawValue)
  
  let min = Expression<Int?>(BCRating.CodingKeys.min.rawValue)
}
//
//  enum CodingKeys: String, CodingTableKey {
//    typealias Root = BCRatingDB
//
//    static let objectRelationalMapping = TableBinding(CodingKeys.self)
//
//    case max, average, min
//    case numRaters = "number_raters"
//    case bookID = "book_id"
//
//    static var tableConstraintBindings: [String : TableConstraintBinding]? {
//      let foreginBinding = ForeignKeyBinding(bookID, foreignKey: BCBook.DB.foreginKey)
//      return ["ForeignKeyBinding": foreginBinding]
//    }
//  }
//
//  init(max: Int?, numRaters: Int?, average: String?, min: Int?) {
//    self.max = max
//    self.numRaters = numRaters
//    self.average = average
//    self.min = min
//  }
//
//  var jsonFormat: BCRating.JSON {
//    BCRating.JSON(max: max, numRaters: numRaters, average: average, min: min)
//  }
//}
