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

final class BCBookStore {
  
  private(set) var book: BCBook?
  
  private(set) var sourceType: SourceType = .networking
  
  private let remote = BCBookRemote()
  
  enum SourceType {
    case database, networking
  }
  //  var isMarked: Bool {
  //    get {}
  //    set {
  //      if newValue {
  //
  //      } else {
  //      }
  //    }
  //  }
  
  func getBook(
    with isbn: String,
    at queue: DispatchQueue = .main,
//    completion: @escaping BCSourceDataResponse<BCBook?, SourceType>
    completion: @escaping BCDataResponse<BCBook?>
  ) {
    let result = BCResult<BCBook?> {
      try BCBookCRUD.get(by: isbn)
    }
    
    if case let .success(value) = result, value != nil {
      book = value
      sourceType = .database
      //      queue.async { completion(.success(value!), .database) }
      queue.async { completion(.success(value!)) }
    } else {
      remote.set(isbn: isbn).fetch { response in
        if case let .success(value) = response {
          self.book = value
          self.sourceType = .networking
        }
        //        queue.async { completion(response, .networking) }
        queue.async { completion(response) }
      }
    }
  }
  
  func mark(
    at queue: DispatchQueue = .main,
    completion: @escaping BCDataResponse<Int64>? = nil
  ) {
    guard book != nil, sourceType == .networking else { return }
    let result = BCResult<Int64> {
      try BCBookCRUD.insert(book!)
    }
    queue.async { completion?(result) }
  }
  
  func unmark(
    at queue: DispatchQueue = .main,
    completion: @escaping BCDataResponse<Int>? = nil
  ) {
    guard book != nil, sourceType == .database else { return }
    let result = BCResult<Int> {
      try BCBookCRUD.delete(by: book!.doubanID)
    }
    queue.async { completion?(result) }
  }
  
  func cancelGetting() { remote.cancel() }
}
//  var isbn10: String? = nil
//  var isbn13: String? = nil
//
//  init(isbn: String) {
//    switch isbn.count {
//      case 10: self.isbn10 = isbn
//      case 13: self.isbn13 = isbn
//      default: break
//    }
//  }
  
//  func mark(
//    at queue: DispatchQueue = .main,
//    completionHanlder: @escaping (Result<Int64, Error>) -> Void
//  ) {
//
//  }
//
//  func unmark(
//    at queue: DispatchQueue = .main,
//    completionHanlder: @escaping (Result<Int, Error>) -> Void
//  ) {
//
//  }
//  func
//}
//import Alamofire
//
//fileprivate let repo = "https://douban-api-git-master.zce.now.sh/"
//
//fileprivate let bookQueryURL = repo + "v2/book/isbn/"
//
//class BCBookStore {
//  let sourceURL: URL?
//
////  let book: BCBook
//
//  init(isbn: String) {
//    self.sourceURL = URL(string: bookQueryURL + isbn)
//  }
//
//  func fetch(
//    at queue: DispatchQueue = .main,
//    completionHandler: @escaping (Result<BCBook, AFError>) -> Void
//  ) {
//    guard let url = sourceURL else { return }
//
//    AF.request(url)
//    .validate()
//      .responseDecodable(of: BCBook.self) { response in
//        queue.async { completionHandler(response.result) }
//    }
//  }
//
//  func cancel() {
//    AF.session.getAllTasks {
//      $0.forEach { task in
//        guard
//          let url = self.sourceURL,
//          let taskURL = task.currentRequest?.url
//          else { return }
//        if taskURL == url { task.cancel() }
//      }
//    }
//  }
//}


//class BCBookInfoService {
//
//  /// A handler to be called when marked book has been written into the database.
//  /// - Parameters:
//  ///   - book: Model entity.
//  ///   - queue: The queue on which the completion handler is dispatched. `.main` by default.
//  ///   - completionHandler: A closure to be excuted once the marking has finished.
//  class func mark(
//    _ book: BCBook,
//    at queue: DispatchQueue = .main,
//    completionHandler: @escaping (BCResult<Int64>) -> Void
//  ) {
//    let group = DispatchGroup()
//    group.enter()
//    BCDB.asyncConnect { conn in
//      let result = BCResult<Int64> {
//        try BCBookDAO.insert(or: .ignore, book, with: conn)
//      }
//      group.leave()
//
//      group.notify(queue: queue) { completionHandler(result) }
//    }
//  }
//
//  /// A handler to be called when unmarked book has been excuted in the database.
//  /// - Parameters:
//  ///   - doubanID: The key for delete condition.
//  ///   - queue: The queue on which the completion handler is dispatched. `.main` by default.
//  ///   - completionHandler: A closure to be excuted once the unmarking has finished.
//  class func unmark(
//    by doubanID: String,
//    at queue: DispatchQueue = .main,
//    completionHandler: @escaping (BCResult<Int>) -> Void
//  ) {
//    let group = DispatchGroup()
//    group.enter()
//    BCDB.asyncConnect { conn in
//      let result = BCResult<Int> {
//        try BCBookDAO.delete(by: doubanID, with: conn)
//      }
//      group.leave()
//
//      group.notify(queue: queue) { completionHandler(result) }
//    }
//  }
//
//  /// A handler to be called when search book with isbn has finished.
//  /// - Parameters:
//  ///   - isbn: The key for search book.
//  ///   - queue: The queue on which the completion handler is dispatched. `.main` by default.
//  ///   - completionHandler: A closure to be excuted once the search has finished.
//  class func search(
//    with isbn: String,
//    at queue: DispatchQueue = .main,
//    completionHandler: @escaping (BCResult<BCBook>) -> Void
//  ) {
//    let group = DispatchGroup()
//    group.enter()
//    BCDB.asyncConnect { conn in
//      let result = BCResult<BCBook> {
//        try BCBookDAO.query(by: isbn, with: conn)
//      }
//      group.leave()
//
//      group.notify(queue: queue) { completionHandler(result) }
//    }
//  }

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
//}
