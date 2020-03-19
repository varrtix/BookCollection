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
}

extension BCBookFoundation { public var id: Int64? { nil } }

protocol BCTagFoundation {
  
  var bookID: Int64? { get }
  
  var count: Int? { get }
  
  var title: String? { get }
}

extension BCTagFoundation { public var bookID: Int64? { nil } }

protocol BCImagesFoundation {
  
  var bookID: Int64? { get }
  
  var small: String? { get }
  
  var medium: String? { get }
  
  var large: String? { get }
}

extension BCImagesFoundation { public var bookID: Int64? { nil } }

protocol BCRatingFoundation {
  
  var bookID: Int64? { get }
  
  var max: Int? { get }
  
  var numRaters: Int? { get }
  
  var average: String? { get }
  
  var min: Int? { get }
}

extension BCRatingFoundation { public var bookID: Int64? { nil } }

protocol BCSeriesFoundation {
  
  var bookID: Int64? { get }
  
  var seriesID: String? { get }
  
  var title: String? { get }
}

extension BCSeriesFoundation { public var bookID: Int64? { nil } }
