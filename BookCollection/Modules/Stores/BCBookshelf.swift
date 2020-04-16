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

final class BCBookshelf {
  
  static let shared = BCBookshelf()
  
  private var contents: [BCBook] = []
  
  var count: Int { contents.count }
  
  init() {
    let database = BCDatabase.TableOperation()
    database.start()
    
    database.completionBlock = { self.puttingBooks() }
  }
  
  subscript(_ index: Int) -> BCBook { contents[index] }

  func remove(_ book: BCBook) {
    guard let index = contents.firstIndex(where: { $0 === book }) else { return }
    book.unmark { [unowned self] res in
      if case let .success(id) = res, id > 0 {
        let removed = self.contents.remove(at: index)
        self.post(removed, userInfo: [
          ChangedNotification.reasonKey: ChangedNotification.ReasonKey.remove,
          ChangedNotification.ValueCache.oldValueKey: index,
        ])
      }
    }
  }
  
  func append(_ book: BCBook) {
    book.mark { [unowned self] res in
      if case let .success(id) = res, id > 0 {
        self.contents.append(book)
        self.post(book, userInfo: [
          ChangedNotification.reasonKey: ChangedNotification.ReasonKey.append,
          ChangedNotification.ValueCache.newValueKey: self.contents.count - 1
        ])
      }
    }
  }
//  func put(book: BCBook, at index: IndexPath? = nil) {
//    book.mark { [unowned self] res in
//      if case let .success(id) = res, id > 0 {
//        if let index = index {
//          self.contents.insert(book, at: index.row)
//        } else {
//          self.contents.append(book)
//        }
//        self.post(book, userInfo: [
//          ChangedNotification.reasonKey: ChangedNotification.ReasonKey.insert,
//          ChangedNotification.ValueCache.newValueKey: index ?? IndexPath(row: self.count, section: 0),
//        ])
//      }
//    }
//  }

//  class func +=(lhs: BCBookshelf, rhs: BCBook) { lhs.put(book: rhs) }
  
  private func puttingBooks() {
    let result = BCResult<[BCBook]?> {
      try BCBookCRUD.multiGet()
    }
    if case let .success(books) = result, books != nil {
      contents = books!
    }
  }
  
  private func post(_ notifying: BCBook, userInfo: [AnyHashable: Any]) {
    NotificationCenter.default.post(name: BCBookshelf.changedNotification, object: notifying, userInfo: userInfo)
  }
}

extension BCBookshelf {
  
  static let changedNotification = Notification.Name("ShelfChangedNotification")
  
  struct ChangedNotification {
//    static let insert = Notification.Name(NSStringFromSelector(#selector(put(book:at:))))
//    static let remove = Notification.Name(NSStringFromSelector(#selector(remove(at:))))
    
    static let reasonKey = "ReasonKey"
    
    static let valueCache = "ValueCache"
    
    enum ReasonKey: String {
      case insert, remove, append
    }
    
    enum ValueCache: String {
      case newValue, oldValue, oldValueKey, newValueKey
    }
  }
}

//  private func launchDatabse() {
//    let database = BCDatabaseOperation()
//    database.start()
//    #if DEBUG
//    // MARK: TODO: Write all logs to a log file
//    print("Database path: \(BCDatabase.fileURL)")
//    #endif
//  }
//
//  class func getAllBooks(
//    withOffset: Int,
//    andSize: Int,
//    at queue: DispatchQueue = .main,
//    completionHandler: @escaping (BCResult<[BCBook]>) -> Void
//  ) {
//    let group = DispatchGroup()
//    group.enter()
//    BCDB.asyncConnect { conn in
//      let result = BCResult<[BCBook]> {
//        try BCBookDAO.queryAll(offset: withOffset, size: andSize, with: conn)
//      }
//      group.leave()
//
//      group.notify(queue: queue) { completionHandler(result) }
//    }
//  }
//
//  class func getBooksCount(completionHandler: @escaping (BCResult<Int>) -> Void) {
//    BCDB.syncConnect { conn in
//      let result = BCResult<Int> {
//        try BCBookDAO.queryCount(with: conn)
//      }
//      completionHandler(result)
//    }
//  }
//}


//class BCBookListService {
//  class func getAllBooks(
//    withOffset: Int,
//    andSize: Int,
//    at queue: DispatchQueue = .main,
//    completionHandler: @escaping (BCResult<[BCBook]>) -> Void
//  ) {
//    let group = DispatchGroup()
//    group.enter()
//    BCDB.asyncConnect { conn in
//      let result = BCResult<[BCBook]> {
//        try BCBookDAO.queryAll(offset: withOffset, size: andSize, with: conn)
//      }
//      group.leave()
//
//      group.notify(queue: queue) { completionHandler(result) }
//    }
//  }
//
//  class func getBooksCount(completionHandler: @escaping (BCResult<Int>) -> Void) {
//    BCDB.syncConnect { conn in
//      let result = BCResult<Int> {
//        try BCBookDAO.queryCount(with: conn)
//      }
//      completionHandler(result)
//    }
//  }
//}
