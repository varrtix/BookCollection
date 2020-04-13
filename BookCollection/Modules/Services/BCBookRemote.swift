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
import Alamofire

final class BCBookRemote {
  
//  static let cancelNotification = Notification.Name("CancelBookRequest")
  
  private var url: URL? = nil
  
  private var request: DataRequest? = nil
  
  init() {}
  
  init(isbn: String) {
    
    set(isbn: isbn)
    //    NotificationCenter.default.addObserver(self, selector: #selector(cancel), name: BCBookRemote.cancelNotification, object: nil)
  }
  
  @discardableResult
  func set(isbn: String) -> Self {
    url = URL(string: BCRemote.bookRemote + isbn)
    request = url == nil ? nil : AF.request(url!)
    
    return self
  }
  
  func fetch(
    at queue: DispatchQueue = .main,
    completion: @escaping BCDataResponse<BCBook?>
  ) {
    request?.validate().responseDecodable(of: BCBook.self) { response in
      switch response.result {
        case .success(let book): queue.async{ completion(.success(book)) }
        case .failure(let error):
          switch error {
            case .responseSerializationFailed(reason: _): queue.async { completion(.success(nil)) }
            default: queue.async { completion(.failure(error)) }
        }
      }
    }
  }
  
//  @objc
  func cancel() { request?.cancel() }
}
