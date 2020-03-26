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

struct BCSeriesDAO: BCDAO {
  typealias Model = BCSeries
  
  @discardableResult
  static func insert(
    or conflict: SQLite.OnConflict,
    _ model: BCSeries,
    with connection: Connection
  ) throws -> Int64 {
    let table = BCDBTable.list[BCDBTable.Kind.series]!
    let series = BCSeriesDB()
    let rowID = try connection.run(table.insert(
      or: conflict,
      series.seriesID <- model.seriesID,
      series.title <- model.title
    ))
    return rowID
  }
  
  static func query(
    by id: Int64,
    with connection: Connection
  ) throws -> BCSeries? {
    let series = try connection.pluck(BCSeriesTable.filter(id == BCSeriesDBD.bookID))
    return series == nil ? nil : BCSeries(result: series!)
  }
}
