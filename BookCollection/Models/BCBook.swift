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
//import SQLite

//let BCBookDBD = BCBookDB.default

//struct BCBook: BCCodable {
struct BCBook: Codable {
  
  let doubanID: String
  
  let title: String?
  
  let subtitle: String?
  
  let originTitle: String?
  
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
  
//  let authors: [String]?
  let authors: Authors?
//  var authors: [String]?
  
//  var translators: [String]?
  let translators: Translators?
  
//  let tags: [BCTag]?
  let tags: Tags?
//  var tags: [BCTag]?
  
//  var images: BCImages?
//  let images: BCImages?
  let images: Images?
  
//  var series: BCSeries?
//  let series: BCSeries?
  let series: Series?
  
//  var rating: BCRating?
//  let rating: BCRating?
  let rating: Rating?
  
  enum CodingKeys: String, CodingKey {
    case doubanID = "id"
    case title, subtitle
    case originTitle = "origin_title"
    case publishedDate = "pubdate"
    case publisher, isbn10, isbn13, image, binding
    case authorIntroduction = "author_intro"
    case catalog, pages, summary, price
    case authors = "author"
    case translators = "translator"
    case tags, images, series, rating
  }
}
//  var type: SourceType = .networking
  
//  init(
//    book: Row,
//    images: BCImages?,
//    series: BCSeries?,
//    rating: BCRating?,
//    tags: [BCTag]?,
//    authors: [BCAuthor]?,
//    translators: [BCTranslator]?
//    type: SourceType
//  ) {
//    self.doubanID = book[BCBookDBD.doubanID]
//    self.title = book [BCBookDBD.title]
//    self.subtitle = book[BCBookDBD.subtitle]
//    self.originTitle = book[BCBookDBD.originTitle]
//    self.publishedDate = book[BCBookDBD.publishedDate]
//    self.publisher = book[BCBookDBD.publisher]
//    self.isbn10 = book[BCBookDBD.isbn10]
//    self.isbn13 = book[BCBookDBD.isbn13]
//    self.image = book[BCBookDBD.image]
//    self.binding = book[BCBookDBD.binding]
//    self.authorIntroduction = book[BCBookDBD.authorIntroduction]
//    self.catalog = book[BCBookDBD.catalog]
//    self.pages = book[BCBookDBD.pages]
//    self.summary = book[BCBookDBD.summary]
//    self.price = book[BCBookDBD.price]
//
//    self.authors = authors
//    self.translators = translators
//    self.tags = tags
//    self.images = images
//    self.series = series
//    self.rating = rating
    
//    self.type = type
//  }
//}

//extension BCBook {
//  enum SourceType: String {
//    case database, networking, unknown
//  }
//}

//struct BCBookDB: BCDBModel {
//struct BCBookDB {
//
//  static let `default` = BCBookDB()
//
//  let id = Expression<Int64>("local_id")
//
//  let doubanID = Expression<String>(BCBook.CodingKeys.doubanID.rawValue)
//
//  let title = Expression<String?>(BCBook.CodingKeys.title.rawValue)
//
//  let subtitle = Expression<String?>(BCBook.CodingKeys.subtitle.rawValue)
//
//  let originTitle = Expression<String?>(BCBook.CodingKeys.originTitle.rawValue)
//
//  let publishedDate = Expression<String?>(BCBook.CodingKeys.publishedDate.rawValue)
//
//  let publisher = Expression<String?>(BCBook.CodingKeys.publisher.rawValue)
//
//  let isbn10 = Expression<String?>(BCBook.CodingKeys.isbn10.rawValue)
//
//  let isbn13 = Expression<String?>(BCBook.CodingKeys.isbn13.rawValue)
//
//  let image = Expression<String?>(BCBook.CodingKeys.image.rawValue)
//
//  let binding = Expression<String?>(BCBook.CodingKeys.binding.rawValue)
//
//  let authorIntroduction = Expression<String?>(BCBook.CodingKeys.authorIntroduction.rawValue)
//
//  let catalog = Expression<String?>(BCBook.CodingKeys.catalog.rawValue)
//
//  let pages = Expression<String?>(BCBook.CodingKeys.pages.rawValue)
//
//  let summary = Expression<String?>(BCBook.CodingKeys.summary.rawValue)
//
//  let price = Expression<String?>(BCBook.CodingKeys.price.rawValue)
//}
