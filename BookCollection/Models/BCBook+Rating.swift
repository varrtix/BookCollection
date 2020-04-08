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
//import SQLite

//let BCRatingDBD = BCRatingDB.default

extension BCBook {
  
  struct Rating: Codable {
    
    let max: Int?
    
    let numRaters: Int?
    
    let average: String?
    
    let min: Int?
    
    enum CodingKeys: String, CodingKey {
      case max, numRaters, average, min
    }
  }
  //  init(result: Row) {
  //    self.max = result[BCRatingDBD.max]
  //    self.numRaters = result[BCRatingDBD.numRaters]
  //    self.min = result[BCRatingDBD.min]
  //    self.average = result[BCRatingDBD.average]
  //  }
}

//struct BCRatingDB {
//
//  static let `default` = BCRatingDB()
//
//  let bookID = Expression<Int64>("book_id")
//
//  let max = Expression<Int?>(BCRating.CodingKeys.max.rawValue)
//
//  let numRaters = Expression<Int?>(BCRating.CodingKeys.numRaters.rawValue)
//
//  let average = Expression<String?>(BCRating.CodingKeys.average.rawValue)
//
//  let min = Expression<Int?>(BCRating.CodingKeys.min.rawValue)
//}
