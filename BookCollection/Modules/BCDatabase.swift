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
        print("Error: \(error)\nfunction: \(#function), line: \(#line) in \(#file).")
      }
    }
    
    return self
  }
}

//let BCDB = BCDatabase.default
//
//struct BCDatabase {
//
//  static let `default` = BCDatabase()
//
//  static var directoryURL: URL {
//    URL(
//      fileURLWithPath: "BCDB",
//      relativeTo: FileManager.documentDirectoryURL)
//  }
//
//  static var fileURL: URL {
//    URL(
//      fileURLWithPath: "Book.sqlite",
//      relativeTo: directoryURL)
//  }
//
//  static let daoQueue = DispatchQueue(
//    label: "com.varrtix.bcdao",
//    qos: .background,
//    attributes: .concurrent)
//
//  static let daoSubQueue = DispatchQueue(
//    label: "com.varrtix.bcsubdao",
//    qos: .background,
//    attributes: .concurrent)
//
//  @discardableResult
//  func check() -> Self {
//    do {
//      if !FileManager.default.fileExists(
//        atPath: BCDatabase
//          .directoryURL
//          .absoluteString) {
//        try FileManager.default.createDirectory(
//          at: BCDatabase.directoryURL,
//          withIntermediateDirectories: true)
//      }
//    } catch { V2RXError.printError(error) }
//
//    return self
//  }
//
//  @discardableResult
//  func asyncConnect(
//    at queue: DispatchQueue = BCDatabase.daoQueue,
//    _ handler: @escaping (Connection) -> Void
//  ) -> Self {
//    do {
//      let connection = try Connection(BCDatabase.fileURL)
//      _ = try connection.prepare("PRAGMA FOREIGN_KEYS=ON")
//      queue.async { handler(connection) }
//    } catch { V2RXError.printError(error) }
//
//    return self
//  }
//
//  @discardableResult
//  func syncConnect(_ handler: @escaping (Connection) -> Void) -> Self {
//    do {
//      let connection = try Connection(BCDatabase.fileURL)
//      _ = try connection.prepare("PRAGMA FOREIGN_KEYS=ON")
//      handler(connection)
//    } catch { V2RXError.printError(error) }
//
//    return self
//  }
//}
