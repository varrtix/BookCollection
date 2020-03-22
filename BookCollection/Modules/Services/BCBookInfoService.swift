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

class BCBookInfoService {
  
  class func mark(book object: BCBook.JSON) throws -> Int64 {
    let database = Database(withFileURL: BCDatabase.fileURL)
    
    guard database.canOpen else {
      print("Database can not open in \(#file): \(#function), \(#line)")
      return -1
    }
    
    let bookID: Int64
    
//    do {
//      guard object.dbFormat.doubanID != nil else { return -1 }
//      bookID = try BCDataAccessObjects.insert(
//        object.bookDB!,
//        with: database,
//        into: .book)
//      guard bookID >= 0 else { return -1 }
//
//      if object.authorsDB != nil {
//        try BCDataAccessObjects.insert(
//          object.authorsDB!,
//          with: database,
//          into: .authors)
//      }
//
//      if object.translatorsDB != nil {
//        try BCDataAccessObjects.insert(
//          object.translatorsDB!,
//          with: database,
//          into: .translators)
//      }
//
//      if object.tagsDB != nil {
//        try BCDataAccessObjects.insert(
//          object.tagsDB!,
//          with: database,
//          into: .tags)
//      }
//
//      if object.imagesDB != nil {
//        try BCDataAccessObjects.insert(
//          object.imagesDB!,
//          with: database,
//          into: .images)
//      }
//
//      if object.seriesDB != nil {
//        try BCDataAccessObjects.insert(
//          object.seriesDB!,
//          with: database,
//          into: .series)
//      }
//
//      if object.ratingDB != nil {
//        try BCDataAccessObjects.insert(
//          object.ratingDB!,
//          with: database,
//          into: .ratings)
//      }
//
//    } catch let error as WCDBSwift.Error { throw error }
    
    return bookID
  }
  
  class func findBook(with doubanID: Int) throws -> BCBook.JSON? {
    let database = Database(withFileURL: BCDatabase.fileURL)
    
    guard database.canOpen else {
      print("Database can not open in \(#file): \(#function), \(#line)")
      return nil
    }
    
    return nil
  }
}
