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
  
  init(book: BCBook) {
    self.book = book
  }
  
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
}
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
