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
import Kingfisher

final class BCBookshelf {
  
  static let shared = BCBookshelf()
  
  private var contents: [BCBook] = []
  
  private(set) var snapshotURLs: [Int: URL] = [:]
  
  var count: Int { contents.count }
  
  init() {
    let database = BCDatabase.TableOperation()
    database.completionBlock = {
      self.puttingBooks()
    }
    
    database.start()
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
  
  func prefetching(by keys: Set<Int>) {
    let urls: [URL] = keys.compactMap { index in
      guard let url = contents[index].image else { return nil }
      snapshotURLs[index] = URL(string: url)
      return snapshotURLs[index]
    }
    ImagePrefetcher(urls: urls).start()
  }

  private func puttingBooks() {
    let result = BCResult<[BCBook]?> {
      try BCBookCRUD.multiGet()
    }
    if case let .success(books) = result, books != nil {
      contents = books!
      NotificationCenter.default.post(
        name: BCBookshelf.changedNotification,
        object: nil,
        userInfo: [
          ChangedNotification.reasonKey: ChangedNotification.ReasonKey.multiLoadingComplete,
      ])
    }
  }
  
  private func post(_ notifying: BCBook, userInfo: [AnyHashable: Any]) {
    NotificationCenter.default.post(name: BCBookshelf.changedNotification, object: notifying, userInfo: userInfo)
  }
}

extension BCBookshelf {
  
  static let changedNotification = Notification.Name("ShelfChangedNotification")
  
  struct ChangedNotification {

    static let reasonKey = "ReasonKey"
    
    static let valueCache = "ValueCache"
    
    enum ReasonKey: String {
      case insert, remove, append, loadingComplete, multiLoadingComplete
    }
    
    enum ValueCache: String {
      case newValue, oldValue, oldValueKey, newValueKey
    }
  }
}
