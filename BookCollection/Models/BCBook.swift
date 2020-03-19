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
import WCDBSwift

// MARK: - Lv. 1th Book model
struct BCBook {
  
  // MARK: - Lv. 2nd Database model
  struct Database: BCBookFoundation, TableCodable {
    
    let id: Int64? = nil
    
    let doubanID: String?
    
    let title: String?
    
    let subtitle: String?
    
    let originTitle: String?
    
    let authors: [String]?
    
    let translators: [String]?
    
    let publishedDate: String?
    
    let publisher: String?
    
    let isbn10: String?
    
    let isbn13: String?
    
    let image: String?
    
    let binding: String?
    
    let authorIntroduction: String?
    
    let catalog: String?
    
    let pages: String?
    
    let summary: String?
    
    let price: String?
    
    
    enum CodingKeys: String, CodingTableKey {
      typealias Root = BCBook.Database
      
      static let objectRelationalMapping = TableBinding(CodingKeys.self)
      
      case id
      case doubanID = "douban_id"
      case title, subtitle
      case originTitle = "origin_title"
      case authors = "author"
      case translators = "translator"
      case publishedDate = "pubdate"
      case publisher, isbn10, isbn13, image, binding
      case authorIntroduction = "author_intro"
      case catalog, pages, summary, price
      
      static var columnConstraintBindings: [BCBook.Database.CodingKeys : ColumnConstraintBinding]? {
        [
          id: ColumnConstraintBinding(isPrimary: true, isAutoIncrement: true, isNotNull: true, isUnique: true),
          doubanID: ColumnConstraintBinding(isUnique: true),
        ]
      }
    }
    
    var isAutoIncrement: Bool = true
    
    var lastInsertedRowID: Int64 = 0
  }
  
  // MARK: - Lv. 2nd Root model
  struct Root: BCBookFoundation, Codable {
    
    let doubanID: String?
    
    let title: String?
    
    let subtitle: String?
    
    let originTitle: String?
    
    let authors: [String]?
    
    let translators: [String]?
    
    let publishedDate: String?
    
    let publisher: String?
    
    let isbn10: String?
    
    let isbn13: String?
    
    let image: String?
    
    let binding: String?
    
    let authorIntroduction: String?
    
    let catalog: String?
    
    let pages: String?
    
    let summary: String?
    
    let price: String?
    
    let tags: [Tag]?
    
    let images: Images?
    
    let series: Series?
    
    let rating: Rating?
    
    enum CodingKeys: String, CodingKey {
      case doubanID = "id"
      case title, subtitle
      case originTitle = "origin_title"
      case authors = "author"
      case translators = "translator"
      case publishedDate = "pubdate"
      case publisher, isbn10, isbn13, image, binding
      case authorIntroduction = "author_intro"
      case catalog, pages, summary, price
      case tags, images, series, rating
    }
    
    var database: Database {
      Database(
        doubanID: doubanID,
        title: title,
        subtitle: subtitle,
        originTitle: originTitle,
        authors: authors,
        translators: translators,
        publishedDate: publishedDate,
        publisher: publisher,
        isbn10: isbn10,
        isbn13: isbn13,
        image: image,
        binding: binding,
        authorIntroduction: authorIntroduction,
        catalog: catalog,
        pages: pages,
        summary: summary,
        price: price
      )
    }
  }
}

// MARK: - Lv. 2nd in Root: Rating, Tag, Images, Series models
extension BCBook.Root {
  
  // MARK: - Lv. 3rd Tag model
  struct Tag: BCTagFoundation, Codable {
    
    let count: Int?
    
    let title: String?
    
    enum CodingKeys: String, CodingKey {
      case count, title
    }
  }
  
  // MARK: - Lv. 3rd Images model
  struct Images: BCImagesFoundation, Codable {
    
    let small: String?
    
    let medium: String?
    
    let large: String?
    
    enum CodingKeys: String, CodingKey {
      case small, medium, large
    }
  }
  
  // MARK: - Lv. 3rd Series model
  struct Series: BCSeriesFoundation, Codable {
    
    let seriesID: String?
    
    let title: String?
    
    enum CodingKeys: String, CodingKey {
      case seriesID = "id"
      case title
    }
  }
  
  // MARK: - Lv. 3rd Rating model
  struct Rating: BCRatingFoundation, Codable {
    
    let max: Int?
    
    let numRaters: Int?
    
    let average: String?
    
    let min: Int?
    
    enum CodingKeys: String, CodingKey {
      case max, numRaters, average, min
    }
  }
}

// MARK: - Lv. 2nd in BCBook: Rating, Tag, Images, Series models
extension BCBook {
  
  // MARK: - Lv. 2nd Tag model
  struct Tag: BCTagFoundation, TableCodable {
    
    let bookID: Int64? = nil
    
    let count: Int?
    
    let title: String?
    
    enum CodingKeys: String, CodingTableKey {
      typealias Root = BCBook.Tag
      
      static let objectRelationalMapping = TableBinding(CodingKeys.self)
      
      case bookID = "book_id"
      case count, title
    }
  }
  
  // MARK: - Lv. 2nd Images model
  struct Images: BCImagesFoundation, TableCodable {
    
    let bookID: Int64? = nil
    
    let small: String?
    
    let medium: String?
    
    let large: String?
    
    enum CodingKeys: String, CodingTableKey {
      typealias Root = BCBook.Images
      
      static let objectRelationalMapping = TableBinding(CodingKeys.self)
      
      case bookID = "book_id"
      case small, medium, large
    }
  }
  
  // MARK: - Lv. 2nd Series model
  struct Series: BCSeriesFoundation, TableCodable {
    
    let bookID: Int64? = nil
    
    let seriesID: String?
    
    let title: String?
    
    enum CodingKeys: String, CodingTableKey {
      typealias Root = BCBook.Series
      
      static let objectRelationalMapping = TableBinding(CodingKeys.self)
      
      case bookID = "book_id"
      case seriesID = "series_id"
      case title
    }
  }
  
  // MARK: - Lv. 2nd Rating model
  struct Rating: BCRatingFoundation, TableCodable {
    
    let bookID: Int64? = nil
    
    let max: Int?
    
    let numRaters: Int?
    
    let average: String?
    
    let min: Int?
    
    enum CodingKeys: String, CodingTableKey {
      typealias Root = BCBook.Rating
      
      static let objectRelationalMapping = TableBinding(CodingKeys.self)
      
      case max, average, min
      case numRaters = "number_raters"
    }
  }
}
