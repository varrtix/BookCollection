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

class BCBookInfoService {
  
  /// A handler to be called when marked book has been written into the database.
  /// - Parameters:
  ///   - book: Model entity.
  ///   - queue: The queue on which the completion handler is dispatched. `.main` by default.
  ///   - completionHandler: A closure to be excuted once the marking has finished.
  class func mark(
    _ book: BCBook,
    at queue: DispatchQueue = .main,
    completionHandler: @escaping (BCResult<Int64>) -> Void
  ) {
    let group = DispatchGroup()
    group.enter()
    BCDB.asyncConnect { conn in
      let result = BCResult<Int64> {
        try BCBookDAO.insert(or: .ignore, book, with: conn)
      }
      group.leave()
      
      group.notify(queue: queue) { completionHandler(result) }
    }
  }
  
  /// A handler to be called when unmarked book has been excuted in the database.
  /// - Parameters:
  ///   - doubanID: The key for delete condition.
  ///   - queue: The queue on which the completion handler is dispatched. `.main` by default.
  ///   - completionHandler: A closure to be excuted once the unmarking has finished.
  class func unmark(
    by doubanID: String,
    at queue: DispatchQueue = .main,
    completionHandler: @escaping (BCResult<Int>) -> Void
  ) {
    let group = DispatchGroup()
    group.enter()
    BCDB.asyncConnect { conn in
      let result = BCResult<Int> {
        try BCBookDAO.delete(by: doubanID, with: conn)
      }
      group.leave()
      
      group.notify(queue: queue) { completionHandler(result) }
    }
  }
  
  /// A handler to be called when search book with isbn has finished.
  /// - Parameters:
  ///   - isbn: The key for search book.
  ///   - queue: The queue on which the completion handler is dispatched. `.main` by default.
  ///   - completionHandler: A closure to be excuted once the search has finished.
  class func search(
    with isbn: String,
    at queue: DispatchQueue = .main,
    completionHandler: @escaping (BCResult<BCBook>) -> Void
  ) {
    let group = DispatchGroup()
    group.enter()
    BCDB.asyncConnect { conn in
      let result = BCResult<BCBook> {
        try BCBookDAO.query(by: isbn, with: conn)
      }
      group.leave()
      
      group.notify(queue: queue) { completionHandler(result) }
    }
  }
  
//  class func get(
//    with isbn: String,
//    at queue: DispatchQueue = .main,
//    completionHandler: @escaping (BCResult<BCBook>) -> Void
//  ) {
////    let bookResult = BCResult<BCBook> {
////      var book: BCBook?
////      var finalError: Error?
////      BCBookInfoService.search(with: isbn) { result in
////        switch result {
////          case .success(let value):
////            book = value
////          case .failure(let error):
////            if let error = error as? V2RXError.DataAccessObjects, error == .notFound {
////              BCBook.fetch(with: isbn) { response in
////                switch response {
////                  case .success(let value): book = value
////                  case .failure(let afError as Error): finalError = afError
////                }
////              }
////            } else { finalError = error }
////        }
////      }
////      if finalError != nil { throw finalError! }
////      return book!
////    }
////    queue.async { completionHandler(bookResult) }
//  }
//
//  class func get(with isbn: String) {
//    BCBookInfoService.search(with: isbn) { result in
//
//    }
//  }
}
