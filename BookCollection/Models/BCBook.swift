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

final class BCBook: Codable {
  
  var isMarked: Bool = false
  
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
  
  let authors: Authors?

  let translators: Translators?
  
  let tags: Tags?

  let images: Images?
  
  let series: Series?
  
  let rating: Rating?
  
  enum CodingKeys: String, CodingKey, CaseIterable {
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
  
  init(
    isMarked: Bool = false,
    doubanID: String,
    title: String?,
    subtitle: String?,
    originTitle: String?,
    publishedDate: String?,
    publisher: String?,
    isbn10: String?,
    isbn13: String?,
    image: String?,
    binding: String?,
    authorIntroduction: String?,
    catalog: String?,
    pages: String?,
    summary: String?,
    price: String?,
    authors: Authors?,
    translators: Translators?,
    tags: Tags?,
    images: Images?,
    series: Series?,
    rating: Rating?
  ) {
    self.isMarked = isMarked
    self.doubanID = doubanID
    self.title = title
    self.subtitle = subtitle
    self.originTitle = originTitle
    self.publishedDate = publishedDate
    self.publisher = publisher
    self.isbn10 = isbn10
    self.isbn13 = isbn13
    self.image = image
    self.binding = binding
    self.authorIntroduction = authorIntroduction
    self.catalog = catalog
    self.pages = pages
    self.summary = summary
    self.price = price
    self.authors = authors
    self.translators = translators
    self.tags = tags
    self.images = images
    self.series = series
    self.rating = rating
  }
}
