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

class BCBookInfoService {
  
  class func mark(
    book object: BCBook.JSON,
    at queue: DispatchQueue = .main,
    completionHandler: @escaping (BCDAOResult<Int64>) -> Void
  ) {
    let database = Database(withFileURL: BCDatabase.fileURL)
    
    var daoResult = BCDAOResult<Int64>(
      result: BCDBResult(value: -1, error: V2RXError.DataAccessObjects.unexpected)
    )
    
    defer { queue.async { completionHandler(daoResult) } }
    
    let root = BCTable(root: object)
    
    BCDataAccessObjects.insert(
      root.book,
      with: database,
      into: .book
    ) {
      handle($0, success: { value in
        daoResult.value = value
      }) { error in
        daoResult.error = error
      }
    }
    
    BCDataAccessObjects.multiInnsert(
      root.authors,
      with: database,
      into: .authors
    ) {
      handle($0) { error in
        daoResult.error = error
      }
    }
    
    BCDataAccessObjects.multiInnsert(
      root.translators,
      with: database,
      into: .translators
    ) {
      handle($0) { error in
        daoResult.error = error
      }
    }
  
    BCDataAccessObjects.multiInnsert(
      root.tags,
      with: database,
      into: .tags
    ) {
      handle($0) { error in
        daoResult.error = error
      }
    }
    
    BCDataAccessObjects.insert(
    root.images,
    with: database,
    into: .images
    ) {
      handle($0) { error in
        daoResult.error = error
      }
    }
    
    BCDataAccessObjects.insert(
      root.series,
      with: database,
      into: .series
    ) {
      handle($0) { error in
        daoResult.error = error
      }
    }
    
    BCDataAccessObjects.insert(
      root.rating,
      with: database,
      into: .rating
    ) {
      handle($0) { error in
        daoResult.error = error
      }
    }
  }
  
  class func findBook(with doubanID: Int) throws -> BCBook.JSON? {
    let database = Database(withFileURL: BCDatabase.fileURL)
    
    guard database.canOpen else {
      print("Database can not open in \(#file): \(#function), \(#line)")
      return nil
    }
    
    return nil
  }
}

extension BCBookInfoService {
  fileprivate class func handle<T: Any>(
    _ result: BCDBResult<T>,
    success handler: ((T) -> ())? = nil,
    failure elseHandler: ((BCError) -> ())? = nil
  ) {
    switch result {
      case .success(let value):
        if handler == nil { return }
        handler!(value)
      case .failure(let error):
        if elseHandler == nil { return }
        elseHandler!(error)
    }
  }
}
