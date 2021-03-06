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

typealias BCTableKind = BCDatabase.Table.Kind

typealias BCLimit = (length: Int?, offset: Int?)

protocol PrimaryKeyCRUD {
  associatedtype Object: Codable
  
  @discardableResult
  static func insert(_ object: Object) throws -> Int64
  
  @discardableResult
  static func get(by key: String) throws -> Object?
  
  @discardableResult
  static func multiGet(limit: BCLimit?) throws -> [Object]?
  
  @discardableResult
  static func delete(by key: String) throws -> Int

  @discardableResult
  static func count() throws -> Int
}

protocol ForeignKeyCRUD {
  associatedtype Object: Codable

  @discardableResult
  static func insert(_ object: Object, by id: Int64) throws -> Int64
  
  @discardableResult
  static func get(by id: Int64) throws -> Object?
}
