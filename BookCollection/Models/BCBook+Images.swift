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

//let BCImagesDBD = BCImagesDB.default

extension BCBook {
  
  struct Images: Codable {
    
    let small: String?
    
    let medium: String?
    
    let large: String?
    
    enum CodingKeys: String, CodingKey {
      case small, medium, large
    }
    
    //  init(result: Row) {
    //    self.small = result[BCImagesDBD.small]
    //    self.medium = result[BCImagesDBD.medium]
    //    self.large = result[BCImagesDBD.large]
    //  }
  }
}

//struct BCImagesDB {
//
//  static let `default` = BCImagesDB()
//
//  let bookID = Expression<Int64>("book_id")
//
//  let small = Expression<String?>(BCImages.CodingKeys.small.rawValue)
//
//  let medium = Expression<String?>(BCImages.CodingKeys.medium.rawValue)
//
//  let large = Expression<String?>(BCImages.CodingKeys.large.rawValue)
//}