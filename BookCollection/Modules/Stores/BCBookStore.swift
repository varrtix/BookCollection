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

final class BCBookStore: NSObject {
  
  private let remote: BCBookRemote
  
  private let isbn: String
  
  init(isbn: String) {
    self.isbn = isbn
    self.remote = BCBookRemote(isbn: isbn)
  }
  
  func getBook(
    at queue: DispatchQueue = .main,
    completion: @escaping BCDataResponse<BCBook?>
  ) {
    let result = BCResult<BCBook?> {
      try BCBookCRUD.get(by: isbn)
    }
    
    if case let .success(value) = result, value != nil {
      queue.async { completion(.success(value!)) }
    } else {
      remote.fetch { response in
        queue.async { completion(response) }
      }
    }
  }
  
  func cancelGetting() { remote.cancel() }
}

extension BCBook {
  func mark(
    at queue: DispatchQueue = .main,
    completion: @escaping BCDataResponse<Int64> = { _ in }
  ) {
    let result = BCResult<Int64> {
      try BCBookCRUD.insert(self)
    }
    
    if case .success(_) = result { self.isMarked = true }
    
    queue.async { completion(result) }
  }
  
  func unmark(
    at queue: DispatchQueue = .main,
    completion: @escaping BCDataResponse<Int> = { _ in }
  ) {
    let result = BCResult<Int> {
      try BCBookCRUD.delete(by: self.doubanID)
    }
    
    if case .success(_) = result { self.isMarked = false }
    
    queue.async { completion(result) }
  }
}
