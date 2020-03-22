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

class BCDataAccessObjects {
  
  @discardableResult
  class func insert<T: BCTableCodable>(
    _ object: T,
    with database: Database,
    into table: BCTable) throws -> Int64 {
    do {
      try database.insert(objects: object, intoTable: table.rawName)
    } catch let error as WCDBSwift.Error { throw error }
    
    return object.lastInsertedRowID
  }
  
  @discardableResult
  class func insert<T: BCTableCodable>(
    _ objects: [T],
    with database: Database,
    into table: BCTable) throws -> Int64 {
    do {
      try database.insert(objects: objects, intoTable: table.rawName)
    } catch let error as WCDBSwift.Error { throw error }
    
    return objects.last!.lastInsertedRowID
  }
  
  class func extractObject(
    queue: DispatchQueue = .main,
    by doubanID: String,
    with database: Database,
    completionHandler: @escaping (BCDAOResult<BCBook.JSON?>) -> Void) {
    
    database.get(
      of: BCBook.DB.self,
      on: BCBook.DB.Properties.doubanID,
      fromTable: BCTable.root.rawName) { result in
    }
  }
}

extension SelectInterface where Self: Core {

  func get<Object: TableDecodable>(
    of type: Object.Type,
    on propertyConvertibleList: PropertyConvertible,
    fromTable table: String,
    where condition: Condition? = nil,
    orderBy orderList: [OrderBy]? = nil,
    offset: Offset? = nil,
    completionHandler: @escaping (BCDBResult<Object?>) -> Void) {
    
    BCDatabase.queue.async {
      let result: BCDBResult<Object?> = Result {
        try self.getObject(
          on: propertyConvertibleList,
          fromTable: table,
          where: condition,
          orderBy: orderList,
          offset: offset)
      }
      completionHandler(result)
    }
  }
}
