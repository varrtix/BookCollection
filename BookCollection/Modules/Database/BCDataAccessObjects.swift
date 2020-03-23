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
  
  class func insert<Object: BCDBCodable>(
    _ object: Object?,
    with database: Database,
    into table: BCTable.Kind,
    or replace: Bool = false,
    on propertyConvertibleList: [PropertyConvertible]? = nil,
    completionHandler: @escaping (BCDBResult<Int64>) -> Void
  ) {
    BCDatabase.queue.async {
      let result: BCDBResult<Int64> = Result {
        guard object != nil else { throw V2RXError.DataAccessObjects.invalidData }
        
        do {
          if replace {
            try database.insertOrReplace(
              objects: object!,
              on: propertyConvertibleList,
              intoTable: table.rawName
            )
          } else {
            try database.insert(
              objects: object!,
              on: propertyConvertibleList,
              intoTable: table.rawName
            )
          }
        } catch { throw error }
        
        return object!.lastInsertedRowID
      }
      completionHandler(result)
    }
  }
  
  class func multiInnsert<Object: BCDBCodable>(
    _ objects: [Object]?,
    with database: Database,
    into table: BCTable.Kind,
    or replace: Bool = false,
    on propertyConvertibleList: [PropertyConvertible]? = nil,
    completionHandler: @escaping (BCDBResult<Int64>) -> Void
  ) {
    BCDatabase.queue.async {
      let result: BCDBResult<Int64> = Result {
        guard objects != nil else { throw V2RXError.DataAccessObjects.invalidData }
        
        do {
          if replace {
            try database.insertOrReplace(
              objects: objects!,
              on: propertyConvertibleList,
              intoTable: table.rawName
            )
          } else {
            try database.insert(
              objects: objects!,
              on: propertyConvertibleList,
              intoTable: table.rawName
            )
          }
        } catch { throw error }
        
        return objects!.last!.lastInsertedRowID
      }
      completionHandler(result)
    }
  }

  class func get<Object: BCDBCodable>(
    of type: Object.Type,
    on propertyConvertibleList: PropertyConvertible,
    from table: BCTable.Kind,
    with database: Database,
    where condition: Condition? = nil,
    orderBy orderList: [OrderBy]? = nil,
    offsetBy offset: Offset? = nil,
    completionHandler: @escaping (BCDBResult<Object?>) -> Void
  ) {
    BCDatabase.queue.async {
      let result: BCDBResult<Object?> = Result {
        try database.getObject(
          on: propertyConvertibleList,
          fromTable: table.rawName,
          where: condition,
          orderBy: orderList,
          offset: offset
        )
      }
      completionHandler(result)
    }
  }
  
  class func multiGet<Object: BCDBCodable>(
    of type: Object.Type,
    on propertyConvertibleList: PropertyConvertible,
    from table: BCTable.Kind,
    with database: Database,
    where condition: Condition? = nil,
    orderBy orderList: [OrderBy]? = nil,
    limitBy limit: Limit? = nil,
    offsetBy offset: Offset? = nil,
    completionHandler: @escaping (BCDBResult<[Object]?>) -> Void
  ) {
    BCDatabase.queue.async {
      let result: BCDBResult<[Object]?> = Result {
        try database.getObjects(
          on: propertyConvertibleList,
          fromTable: table.rawName,
          where: condition,
          orderBy: orderList,
          limit: limit,
          offset: offset
        )
      }
      completionHandler(result)
    }
  }
}

extension BCDataAccessObjects {
  
  class func extractObject(
    queue: DispatchQueue = .main,
    by doubanID: String,
    with database: Database,
    completionHandler: @escaping (BCDAOResult<BCBook.JSON?>) -> Void) {
    
    var resultJSON = BCDAOResult<BCBook.JSON?>(value: nil, error: nil)
    
    database.get(
      of: BCBook.DB.self,
      on: BCBook.DB.Properties.doubanID,
      fromTable: BCTable.Kind.book.rawName,
      where: BCBook.DB.Properties.doubanID == doubanID
    ) { result in
      
      var book: BCBook.JSON?
      
      guard case let .success(value) = result else {
        guard case let .failure(error) = result else {
          resultJSON.result = .failure(V2RXError.DataAccessObjects.unexpected)
          return
        }
        
        resultJSON.result = .failure(error)
        return
      }
      
      book = value?.bookJSON
      
      guard let id = value?.id else {
        resultJSON.result = .failure(V2RXError.DataAccessObjects.invalidForeignKey)
        return
      }
      
      database.multiGet(
        of: BCAuthor.DB.self,
        on: BCAuthor.DB.Properties.bookID,
        fromTable: BCTable.authors.rawName,
        where: BCAuthor.DB.Properties.bookID == id
      ) { authors in
        guard case let .success(subValue) = authors, subValue != nil else {
          guard case let .failure(error) = authors else {
            resultJSON.result = .failure(V2RXError.DataAccessObjects.unexpected)
            return
          }
          resultJSON.result = .failure(error)
          return
        }
        book?.authors = subValue!.map { $0.jsonFormat }
      }
      
      database.multiGet(
        of: BCTranslator.DB.self,
        on: BCTranslator.DB.Properties.bookID,
        fromTable: BCTable.translators.rawName,
        where: BCTranslator.DB.Properties.bookID == id
      ) { translators in
        guard case let .success(subValue) = translators, subValue != nil else {
          guard case let .failure(error) = translators else {
            resultJSON.result = .failure(V2RXError.DataAccessObjects.unexpected)
            return
          }
          resultJSON.result = .failure(error)
          return
        }
        book?.translators = subValue!.map { $0.jsonFormat }
      }
      
      database.multiGet(
        of: BCTag.DB.self,
        on: BCTag.DB.Properties.bookID,
        fromTable: BCTable.tags.rawName,
        where: BCTranslator.DB.Properties.bookID == id
      ) { tags in
        guard case let .success(subValue) = tags, subValue != nil else {
          guard case let .failure(error) = tags else {
            resultJSON.result = .failure(V2RXError.DataAccessObjects.unexpected)
            return
          }
          resultJSON.result = .failure(error)
          return
        }
        book?.tags = subValue!.map { $0.jsonFormat }
      }
      
      resultJSON.result = .success(book)
    }
    
    queue.async {
      completionHandler(resultJSON)
    }
  }
}
