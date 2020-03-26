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

protocol BCDAO {
  associatedtype Model
  
  static func insert(or conflict: SQLite.OnConflict, _ model: Model, with connection: Connection) throws -> Int64
                                                  
}

//class BCDataAccessObjects {
//  
//  class func insert<Object: bc>(
//    _ object: Object?,
//    with database: Connection,
//    into table: BCDBTable.Kind,
//    or replace: Bool = false,
//    on propertyConvertibleList: [PropertyConvertible]? = nil,
//    at queue: DispatchQueue = BCDatabase.queue,
//    completionHandler: @escaping (BCDBResult<Int64>) -> Void
//  ) {
//    database.run(book.insert(<#T##value: Setter##Setter#>, <#T##more: Setter...##Setter#>))
//    queue.async {
//      let result: BCDBResult<Int64> = Result {
//        guard object != nil else { throw V2RXError.DataAccessObjects.invalidData }
//        
//        do {
//          if replace {
//            try database.insertOrReplace(
//              objects: object!,
//              on: propertyConvertibleList,
//              intoTable: table.rawName
//            )
//          } else {
//            try database.insert(
//              objects: object!,
//              on: propertyConvertibleList,
//              intoTable: table.rawName
//            )
//          }
//        } catch { throw error }
//        
//        return object!.lastInsertedRowID
//      }
//      completionHandler(result)
//    }
//  }
//  
//  class func multiInnsert<Object: BCDBCodable>(
//    _ objects: [Object]?,
//    with database: Database,
//    into table: BCDBTable.Kind,
//    or replace: Bool = false,
//    on propertyConvertibleList: [PropertyConvertible]? = nil,
//    at queue: DispatchQueue = BCDatabase.queue,
//    completionHandler: @escaping (BCDBResult<Int64>) -> Void
//  ) {
//    queue.async {
//      let result: BCDBResult<Int64> = Result {
//        guard objects != nil else { throw V2RXError.DataAccessObjects.invalidData }
//        
//        do {
//          if replace {
//            try database.insertOrReplace(
//              objects: objects!,
//              on: propertyConvertibleList,
//              intoTable: table.rawName
//            )
//          } else {
//            try database.insert(
//              objects: objects!,
//              on: propertyConvertibleList,
//              intoTable: table.rawName
//            )
//          }
//        } catch { throw error }
//        
//        return objects!.last!.lastInsertedRowID
//      }
//      completionHandler(result)
//    }
//  }
//  
//  class func get<Object: BCDBCodable>(
//    of type: Object.Type,
//    on propertyConvertibleList: PropertyConvertible,
//    from table: BCDBTable.Kind,
//    with database: Database,
//    where condition: Condition? = nil,
//    orderBy orderList: [OrderBy]? = nil,
//    offsetBy offset: Offset? = nil,
//    at queue: DispatchQueue = BCDatabase.queue,
//    completionHandler: @escaping (BCDBResult<Object>) -> Void
//  ) {
//    queue.async {
//      let result: BCDBResult<Object> = Result {
//        do {
//          let object: Object? = try database.getObject(
//            on: propertyConvertibleList,
//            fromTable: table.rawName,
//            where: condition,
//            orderBy: orderList,
//            offset: offset
//          )
//          guard object != nil else { throw V2RXError.DataAccessObjects.notFound }
//          return object!
//        } catch { throw error }
//      }
//      completionHandler(result)
//    }
//  }
//  
//  class func multiGet<Object: BCDBCodable>(
//    of type: Object.Type,
//    on propertyConvertibleList: PropertyConvertible,
//    from table: BCDBTable.Kind,
//    with database: Database,
//    where condition: Condition? = nil,
//    orderBy orderList: [OrderBy]? = nil,
//    limitBy limit: Limit? = nil,
//    offsetBy offset: Offset? = nil,
//    at queue: DispatchQueue = BCDatabase.queue,
//    completionHandler: @escaping (BCDBResult<[Object]>) -> Void
//  ) {
//    queue.async {
//      let result: BCDBResult<[Object]> = Result {
//        do {
//          let object: [Object] = try database.getObjects(
//            on: propertyConvertibleList,
//            fromTable: table.rawName,
//            where: condition,
//            orderBy: orderList,
//            limit: limit,
//            offset: offset
//          )
//          if object.isEmpty { throw V2RXError.DataAccessObjects.notFound }
//          return object
//        } catch { throw error }
//      }
//      completionHandler(result)
//    }
//  }
//}
