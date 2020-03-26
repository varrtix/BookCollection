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

class BCBookInfoService {
  
  /// A handler to be called when marked book has been written into the database.
  /// - Parameters:
  ///   - book: Model entity.
  ///   - queue: The queue on which the completion handler is dispatched. `.main` by default.
  ///   - completionHandler: A closure to be excuted once the marking has finished.
  class func mark(
    _ book: BCBook,
    at queue: DispatchQueue = .main,
    completionHandler: @escaping (BCResult<Int64>) -> Void
  ) {
    do {
      
      let connection = try Connection(BCDatabase.fileURL)
      
      BCDatabase.daoQueue.async {
        
        let result = BCResult<Int64> {
          try BCBookDAO.insert(or: .ignore, book, with: connection)
        }
        
        let subResult = BCResult<Int64> {
          let tagError = BCErrorResult<Int64>().catching {
            guard book.tags != nil
              else { throw V2RXError.DataAccessObjects.invalidData }
            try book.tags!.forEach {
              try BCTagDAO.insert(or: .ignore, $0, with: connection)
            }
            return 0
          }
          if tagError != nil { throw tagError! }
          
          let imageError = BCErrorResult<Int64>().catching {
            guard book.images != nil
              else { throw V2RXError.DataAccessObjects.invalidData }
            return try BCImagesDAO.insert(or: .ignore, book.images!, with: connection)
          }
          if imageError != nil { throw imageError! }
          
          let seriesError = BCErrorResult<Int64>().catching {
            guard book.series != nil
              else { throw V2RXError.DataAccessObjects.invalidData }
            return try BCSeriesDAO.insert(or: .ignore, book.series!, with: connection)
          }
          if seriesError != nil { throw seriesError! }
          
          let ratingError = BCErrorResult<Int64>().catching {
            guard book.rating != nil
              else { throw V2RXError.DataAccessObjects.invalidData }
            return try BCRatingDAO.insert(or: .ignore, book.rating!, with: connection)
          }
          if ratingError != nil { throw ratingError! }
          
          let authorError = BCErrorResult<Int64>().catching {
            guard book.authors != nil
              else { throw V2RXError.DataAccessObjects.invalidData }
            try book.authors!.forEach {
              try BCAuthorDAO.insert(or: .ignore, $0, with: connection)
            }
            return 0
          }
          if authorError != nil { throw authorError! }
          
          let translatorError = BCErrorResult<Int64>().catching {
            guard book.translators != nil
              else { throw V2RXError.DataAccessObjects.invalidData }
            try book.translators!.forEach {
              try BCTranslatorDAO.insert(or: .ignore, $0, with: connection)
            }
            return 0
          }
          if translatorError != nil { throw translatorError! }
          
          return 0
        }
        
        guard case .failure(_) = subResult else {
          queue.async { completionHandler(result) }
          return
        }
        queue.async { completionHandler(subResult) }
      }
    } catch { V2RXError.printError(error) }
  }
  
  class func search(
    with doubanID: String,
    at queue: DispatchQueue = .main,
    completionHandler: @escaping (BCResult<BCBook?>) -> Void
  ) {
    do {
      
      let connection = try Connection(BCDatabase.fileURL)
      
      BCDatabase.daoQueue.async {
        let result = BCResult<BCBook?> {
          try BCBookDAO.query(by: doubanID, with: connection)
        }
        
        queue.async { completionHandler(result) }
      }
    } catch {
      V2RXError.printError(error)
    }
  }
}
