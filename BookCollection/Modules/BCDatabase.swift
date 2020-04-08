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

let DB = BCDatabase.shared

final class BCDatabase {
  
  static let shared = BCDatabase()
  
  var connection: Connection? {
    do {
      return try Connection(file)
//      let connection = try Connection(file)
//      _ = try connection.prepare("PRAGMA FOREIGN_KEYS = ON")
//      return connection
    } catch {
      print("Connect error: \(error)\nfunction: \(#function), line: \(#line) in \(#file).")
      return nil
    }
  }
  
  private let directory: URL
  
  private let file: URL
  
  private init() {
    directory = URL(fileURLWithPath: "BCDB", relativeTo: FileManager.documentDirectory)
    file = URL(fileURLWithPath: "Book.sqlite", relativeTo: directory)
    
  }

  @discardableResult
  func validate() -> Self {
    if !FileManager.default.fileExists(atPath: directory.absoluteString) {
      
      do {
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
      } catch {
        print("URL error: \(error)\nfunction: \(#function), line: \(#line) in \(#file).")
      }
    }
    
    return self
  }
}

extension Connection {
  func pragma(_ pragma: Pragma) -> Self {
    _ = try? self.prepare("PRAGMA " + pragma.statement)
    return self
  }
  
  enum Pragma {
    case fetch(String)
    case foreignKeys(Bool)
    
    var statement: String {
      switch self {
        case let .foreignKeys(sign): return "FOREIGN_KEYS = \(sign ? "ON" : "OFF")"
        case let .fetch(value): return value
      }
    }
  }
}
