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

// MARK: - Top level: Book model
struct BCBook {
  // Part of DB model
  struct DB: BCBookFoundation, TableCodable {

    let bookID: String
    
    let title: String
    
    let subtitle: String
    
    let originTitle: String
    
    let author: [String]
    
    let translator: [String]
    
    let publishedDate: String
    
    let publisher: String
    
    let isbn10: String
    
    let isbn13: String
    
    let image: String
    
    let binding: String
    
    let authorIntroduction: String
    
    let catalog: String
    
    let pages: String
    
    let summary: String
    
    let price: String
    
    
    enum CodingKeys: String, CodingTableKey {
      typealias Root = BCBook.DB
      
      static let objectRelationalMapping = TableBinding(CodingKeys.self)
      
      case bookID = "book_id"
      case title, subtitle
      case originTitle = "origin_title"
      case author, translator
      case publishedDate = "pubdate"
      case publisher, isbn10, isbn13, image, binding
      case authorIntroduction = "author_intro"
      case catalog, pages, summary, price
    }
  }
  
  // Part of Coder model
  struct Coder: BCBookFoundation, Codable {
    
    let bookID: String
    
    let title: String
    
    let subtitle: String
    
    let originTitle: String
    
    let author: [String]
    
    let translator: [String]
    
    let publishedDate: String
    
    let publisher: String
    
    let isbn10: String
    
    let isbn13: String
    
    let image: String
    
    let binding: String
    
    let authorIntroduction: String
    
    let catalog: String
    
    let pages: String
    
    let summary: String
    
    let price: String
    
    let tags: [Tag]?
    
    let images: Images?
    
    let series: Series?
    
    let rating: Rating?
    
    enum CodingKeys: String, CodingKey {
      case bookID = "id"
      case title, subtitle
      case originTitle = "origin_title"
      case author, translator
      case publishedDate = "pubdate"
      case publisher, isbn10, isbn13, image, binding
      case authorIntroduction = "author_intro"
      case catalog, pages, summary, price
      case tags, images, series, rating
    }
    
    var dbFormat: DB {
      DB(
        bookID: bookID,
        title: title,
        subtitle: subtitle,
        originTitle: originTitle,
        author: author,
        translator: translator,
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

// MARK: - Second level: Rating, Tag, Images, Series
extension BCBook.Coder {
  struct Tag: BCTagFoundation, Codable {
    
    let count: Int
    
    let title: String
    
    enum CodingKeys: String, CodingKey {
      case count, title
    }
  }
  
  struct Images: BCImagesFoundation, Codable {
    
    let small: String
    
    let medium: String
    
    let large: String
    
    enum CodingKeys: String, CodingKey {
      case small, medium, large
    }
  }
  
  struct Series: BCSeriesFoundation, Codable {
    
    let id: String
    
    let title: String

    enum CodingKeys: String, CodingKey {
      case id, title
    }
  }
  
  struct Rating: BCRatingFoundation, Codable {
    
    let max: Int
    
    let numRaters: Int
    
    let average: String
    
    let min: Int
    
    enum CodingKeys: String, CodingKey {
      case max, numRaters, average, min
    }
  }
}
