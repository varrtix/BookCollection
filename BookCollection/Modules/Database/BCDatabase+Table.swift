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
  
  func create(with connection: Connection) {
    do {
      switch self {
        case .book:
          try connection.run(self.table.create(ifNotExists: true) {
            $0.column(TBBook.id, primaryKey: .autoincrement)
            $0.column(TBBook.doubanID, unique: true)
            $0.column(TBBook.title)
            $0.column(TBBook.subtitle)
            $0.column(TBBook.originTitle)
            $0.column(TBBook.publishedDate)
            $0.column(TBBook.publisher)
            $0.column(TBBook.isbn10)
            $0.column(TBBook.isbn13)
            $0.column(TBBook.image)
            $0.column(TBBook.binding)
            $0.column(TBBook.authorIntroduction)
            $0.column(TBBook.catalog)
            $0.column(TBBook.pages)
            $0.column(TBBook.summary)
            $0.column(TBBook.price)
          })
        
        case .tags:
          try connection.run(self.table.create(ifNotExists: true) {
            $0.column(TBTags.id)
            $0.column(TBTags.count)
            $0.column(TBTags.title)
            $0.foreignKey(
              TBTags.id,
              references: self.table, TBBook.id,
              delete: .cascade
            )
          })
        
        case .images:
          try connection.run(self.table.create(ifNotExists: true) {
            $0.column(TBImages.id)
            $0.column(TBImages.small)
            $0.column(TBImages.medium)
            $0.column(TBImages.large)
            $0.foreignKey(
              TBImages.id,
              references: self.table, TBBook.id,
              delete: .cascade
            )
          })
        
        case .series:
          try connection.run(self.table.create(ifNotExists: true) {
            $0.column(TBSeries.id)
            $0.column(TBSeries.seriesID)
            $0.column(TBSeries.title)
            $0.foreignKey(
              TBSeries.id,
              references: self.table, TBBook.id,
              delete: .cascade
            )
          })
        
        case .rating:
          try connection.run(self.table.create(ifNotExists: true) {
            $0.column(TBRating.id)
            $0.column(TBRating.max)
            $0.column(TBRating.numRaters)
            $0.column(TBRating.min)
            $0.column(TBRating.average)
            $0.foreignKey(
              TBRating.id,
              references: self.table, TBBook.id,
              delete: .cascade
            )
          })
        
        case .authors:
          try connection.run(self.table.create(ifNotExists: true) {
            $0.column(TBAuthors.id)
            $0.column(TBAuthors.name)
            $0.foreignKey(
              TBAuthors.id,
              references: self.table, TBBook.id,
              delete: .cascade
            )
          })
        
        case .translators:
          try connection.run(self.table.create(ifNotExists: true) {
            $0.column(TBTranslators.id)
            $0.column(TBTranslators.name)
            $0.foreignKey(
              TBTranslators.id,
              references: self.table, TBBook.id,
              delete: .cascade
            )
          })
      }
    } catch {
      print("Create error: \(error)")
    }
  }
}
