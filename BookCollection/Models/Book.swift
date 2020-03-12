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

// MARK: - Top level: Book model
struct Book: Codable {
  let rating: Rating
  let subtitle: String
  let author: [String]
  let publishedDate: String
  let tags: [Tag]
  let originTitle: String
  let image: String
  let binding: String
  let translator: [String]
  let catalog: String
  let pages: String
  let images: Images
  let id: String
  let publisher: String
  let isbn10: String
  let isbn13: String
  let title: String
  let authorIntroduction: String
  let summary: String
  let price: String
  
  enum CodingKeys: String, CodingKey {
    case rating, subtitle, author, tags
    case image, binding, translator, catalog, pages
    case images, id, publisher, isbn10, isbn13
    case title, summary, price
    case publishedDate = "pubdate"
    case authorIntroduction = "author_intro"
    case originTitle = "origin_title"
  }
}

// MARK: - Second level: Rating, Tag, Images, Series
extension Book {
  struct Rating: Codable {
    let max: Int
    let average: String
    let min: Int
    let numRaters: Int
    
    enum CodingKeys: String, CodingKey {
      case max, average, min, numRaters
    }
  }
  
  struct Tag: Codable {
    let count: Int
    let title: String
    
    enum CodingKeys: String, CodingKey {
      case count, title
    }
  }
  
  struct Images: Codable {
    let small: String
    let medium: String
    let large: String
    
    enum CodingKeys: String, CodingKey {
      case small, medium, large
    }
  }
}
