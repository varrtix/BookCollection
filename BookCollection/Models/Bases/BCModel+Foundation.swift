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

protocol BCModelFoundation {}

protocol BCModelDB { associatedtype DB: Codable }

protocol BCModelJSON { associatedtype JSON: Codable }

typealias BCModelORM = BCModelDB & BCModelJSON

protocol BCModelEncodable: Encodable, BCModelFoundation {}

protocol BCModelDecodable: Decodable, BCModelFoundation {}

typealias BCModelCodable = BCModelEncodable & BCModelDecodable

protocol BCBookFoundation {
  
  var id: Int64? { get }
  
  var doubanID: String? { get }
  
  var title: String? { get }
  
  var subtitle: String? { get }
  
  var originTitle: String? { get }
  
  var authors: [String]? { get }
  
  var translators: [String]? { get }
  
  var publishedDate: String? { get }
  
  var publisher: String? { get }
  
  var isbn10: String? { get }
  
  var isbn13: String? { get }
  
  var image: String? { get }
  
  var binding: String? { get }
  
  var authorIntroduction: String? { get }
  
  var catalog: String? { get }
  
  var pages: String? { get }
  
  var summary: String? { get }
  
  var price: String? { get }
  
  var tags: [BCTagFoundation]? { get }
  
  var images: BCImagesFoundation? { get }
  
  var series: BCSeriesFoundation? { get }
  
  var rating: BCRatingFoundation? { get }
}

extension BCBookFoundation {
  
  var id: Int64? { nil }
  
  var authors: [String]? { nil }
  
  var translators: [String]? { nil }
  
  var tags: [BCTagFoundation]? { nil }
  
  var images: BCImagesFoundation? { nil }
  
  var series: BCSeriesFoundation? { nil }
  
  var rating: BCRatingFoundation? { nil }
}

protocol BCBookPrimaryKey { var bookID: Int64? { get } }

extension BCBookPrimaryKey { var bookID: Int64? { nil } }

protocol BCTagFoundation: BCBookPrimaryKey {
  
  var count: Int? { get }
  
  var title: String? { get }
}

protocol BCImagesFoundation: BCBookPrimaryKey {
  
  var small: String? { get }
  
  var medium: String? { get }
  
  var large: String? { get }
}

protocol BCRatingFoundation: BCBookPrimaryKey {
  
  var max: Int? { get }
  
  var numRaters: Int? { get }
  
  var average: String? { get }
  
  var min: Int? { get }
}

protocol BCSeriesFoundation: BCBookPrimaryKey {
  
  var seriesID: String? { get }
  
  var title: String? { get }
}

protocol BCAuthorFoundation: BCBookPrimaryKey { var name: String? { get } }
