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

typealias BCResult<Success> = Result<Success, Error>

struct BCDBResult {
  static func handle<T: Any>(
    _ result: BCResult<T>,
    success handler: ((T) -> ())? = nil,
    failure elseHandler: ((Error) -> ())? = nil
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

struct BCErrorResult<Success>: Error {
  func catching(_ body: () throws -> Success) -> Error? {
    let result = BCResult<Success>(catching: body)
    guard case let .failure(error) = result else { return nil }
    return error
  }
}
//typealias BCDBResult<Success> = Result<Success, BCError>
//
//typealias BCDAOResult<Success> = BCResult<Success, BCError>
//
//struct BCResult<Success, Failure: BCError> {
//
//  var result: Result<Success, Failure>
//
//  var value: Success? {
//    get { result.success }
//    set {
//      guard newValue != nil else { return }
//      self.result = .success(newValue!)
//    }
//  }
//
//  var error: Failure? {
//    get { result.failure }
//    set {
//      guard newValue != nil else { return }
//      self.result = .failure(newValue!)
//    }
//  }
//
//  init(result: Result<Success, Failure>) { self.result = result }
//
//  init(value: Success, error: Failure?) {
//    if let error = error {
//      self.result = .failure(error)
//    } else {
//      self.result = .success(value)
//    }
//  }
//}
//
//extension Result {
//  var success: Success? {
//    guard case let .success(value) = self else { return nil }
//    return value
//  }
//
//  var failure: Failure? {
//    guard case let .failure(error) = self else { return nil }
//    return error
//  }
//
//  init(value: Success, error: Failure?) {
//    if let error = error {
//      self = .failure(error)
//    } else {
//      self = .success(value)
//    }
//  }
//}
