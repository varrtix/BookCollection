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
//import SQLite

class BCBookInfoService {
  
  class func mark(
    book object: BCBook,
    at queue: DispatchQueue = .main,
    completionHandler: @escaping (BCResult<Int64>) -> Void
  ) {
    let database = Database(withFileURL: BCDatabase.fileURL)
    
    var daoResult = BCDAOResult<Int64>(result: BCDBResult(value: -1, error: nil))
    
    let root = BCDBTable(root: object)
    
//    defer { queue.async { completionHandler(daoResult) } }
    let group = DispatchGroup()
    
    group.enter()
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
      group.leave()
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
    
    group.notify(queue: queue) {
      completionHandler(daoResult)
    }
  }
  
  class func search(
    with doubanID: String,
    at queue: DispatchQueue = .main,
    completionHandler: @escaping (BCDAOResult<BCBook.JSON?>) -> Void
  ) {
    let database = Database(withFileURL: BCDatabase.fileURL)
    
    var daoResult = BCDAOResult<BCBook.JSON?>(value: nil, error: nil)
    
    let group = DispatchGroup()
    
    group.enter()
    BCDataAccessObjects.get(
      of: BCBook.DB.self,
      on: BCBook.DB.Properties.doubanID,
      from: .book,
      with: database,
      where: BCBook.DB.Properties.doubanID == doubanID
    ) {
      handle($0, success: { value in
        daoResult.value = value.jsonFormat
      }) { error in
        daoResult.error = error
      }
      group.leave()
    }
    
    defer { queue.async { completionHandler(daoResult) } }
    
    let dispatchItem = DispatchWorkItem(qos: .background) {
      
      guard let id = daoResult.value??.doubanID else {
        daoResult.error = V2RXError.DataAccessObjects.invalidForeignKey
        return
      }
      
      BCDataAccessObjects.get(
        of: BCImages.DB.self,
        on: BCImages.DB.Properties.bookID,
        from: .images,
        with: database,
        where: BCImages.DB.Properties.bookID == id
      ) {
        handle($0, success: { value in
          daoResult.value??.images = value.jsonFormat
        })
      }
      
      BCDataAccessObjects.get(
        of: BCSeries.DB.self,
        on: BCSeries.DB.Properties.bookID,
        from: .series,
        with: database,
        where: BCSeries.DB.Properties.bookID == id
      ) {
        handle($0, success: { value in
          daoResult.value??.series = value.jsonFormat
        })
      }
      
      BCDataAccessObjects.get(
        of: BCRating.DB.self,
        on: BCRating.DB.Properties.bookID,
        from: .rating,
        with: database,
        where:  BCRating.DB.Properties.bookID == id
      ) {
        handle($0, success: { value in
          daoResult.value??.rating = value.jsonFormat
        })
      }
      
      BCDataAccessObjects.multiGet(
        of: BCTag.DB.self,
        on: BCTag.DB.Properties.bookID,
        from: .tags,
        with: database,
        where: BCTag.DB.Properties.bookID == id
      ) {
        handle($0, success: { value in
          daoResult.value??.tags = value.map { $0.jsonFormat }
        })
      }
      
      BCDataAccessObjects.multiGet(
        of: BCAuthor.DB.self,
        on: BCAuthor.DB.Properties.bookID,
        from: .authors,
        with: database,
        where: BCAuthor.DB.Properties.bookID == id
      ) {
        handle($0, success: { value in
          daoResult.value??.authors = value.map { $0.jsonFormat }
        })
      }
      
      BCDataAccessObjects.multiGet(
        of: BCTranslator.DB.self,
        on: BCTranslator.DB.Properties.bookID,
        from: .translators,
        with: database,
        where: BCTranslator.DB.Properties.bookID == id
      ) {
        handle($0, success: { value in
          daoResult.value??.translators = value.map { $0.jsonFormat }
        })
      }
    }
    
    group.notify(queue: BCDatabase.queue, work: dispatchItem)
  }
}

extension BCBookInfoService {
//  class func handle<T: Any>(
//    _ result: BCDBResult<T>,
//    success handler: ((T) -> ())? = nil,
//    failure elseHandler: ((BCError) -> ())? = nil
//  ) {
//    switch result {
//      case .success(let value):
//        if handler == nil { return }
//        handler!(value)
//      case .failure(let error):
//        if elseHandler == nil { return }
//        elseHandler!(error)
//    }
//  }
}
