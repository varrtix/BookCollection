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

protocol BCConvertibleExpression {

  func int64Exp(_ key: String) -> Expression<Int64>
  
  func int64Exp(_ key: CodingKey) -> Expression<Int64>
  
  func optIntExp(_ key: String) -> Expression<Int?>

  func optIntExp(_ key: CodingKey) -> Expression<Int?>
  
  func stringExp(_ key: String) -> Expression<String>

  func stringExp(_ key: CodingKey) -> Expression<String>
  
  func optStringExp(_ key: String) -> Expression<String?>

  func optStringExp(_ key: CodingKey) -> Expression<String?>
}

extension BCDatabase {
  
  class Table: BCConvertibleExpression {

    static let shared = Table()

    enum Kind: String, CaseIterable {
      case book, authors, translators
      case tags, images, series, rating
      
      var raw: String { "TB_BC_" + self.rawValue.uppercased() }
    }
    
    func int64Exp(_ key: String) -> Expression<Int64> {
      Expression<Int64>(key)
    }
    
    func int64Exp(_ key: CodingKey) -> Expression<Int64> {
      int64Exp(key.stringValue)
    }
    
    func stringExp(_ key: String) -> Expression<String> {
      Expression<String>(key)
    }
    
    func stringExp(_ key: CodingKey) -> Expression<String> {
      stringExp(key.stringValue)
    }
    
    func optStringExp(_ key: String) -> Expression<String?> {
      Expression<String?>(key)
    }

    func optStringExp(_ key: CodingKey) -> Expression<String?> {
      optStringExp(key.stringValue)
    }
    
    func optIntExp(_ key: String) -> Expression<Int?> {
      Expression<Int?>(key)
    }
    
    func optIntExp(_ key: CodingKey) -> Expression<Int?> {
      optIntExp(key.stringValue)
    }
  }
}

extension BCDatabase.Table.Kind {

  var table: Table { Table(self.raw) }

  var columns: [Expressible] {
    var columns: [Expressible] = [Expression<Int64>("book_id")]
    
    switch self {
      case .book:
        columns = [Expression<Int64>("local_id")]
        columns += BCBook.CodingKeys.allCases.compactMap {
          element -> Expressible? in
          
          switch element {
            case .doubanID: return Expression<String>(element.rawValue)
            case .authors, .translators, .tags, .images, .series, .rating: return nil
            default: return Expression<String?>(element.rawValue)
          }
      }
      
      case .authors, .translators:
        columns.append(Expression<String?>("name"))
      
      case .tags:
        columns += BCBook.Tag.CodingKeys.allCases.compactMap {
          element -> Expressible? in
          
          switch element {
            case .count: return Expression<Int?>(element.rawValue)
            case .title: return Expression<String?>(element.rawValue)
          }
      }
      
      case .images:
        columns += BCBook.Images.CodingKeys.allCases.compactMap {
          element -> Expressible? in
          
          switch element {
            default: return Expression<String?>(element.rawValue)
          }
      }
      
      case .series:
        columns += BCBook.Series.CodingKeys.allCases.compactMap {
          element -> Expressible? in
          
          switch element {
            default: return Expression<String?>(element.rawValue)
          }
      }
      
      case .rating:
        columns += BCBook.Rating.CodingKeys.allCases.compactMap {
          element -> Expressible? in
          
          switch element {
            case .average: return Expression<String?>(element.rawValue)
            default: return Expression<Int?>(element.rawValue)
          }
      }
    }
    
    return columns
  }
}
