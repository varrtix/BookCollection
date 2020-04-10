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

let TBBook = BCBookTable.shared

struct BCBookTable: BCTable {
  
  static let shared = BCBookTable()
  
  typealias Keys = BCBook.CodingKeys
  
  let kind: Table.Kind = .book
  
  let id = TB.int64Exp("local_id")
  
  let doubanID = TB.stringExp(Keys.doubanID)
  
  let title = TB.optStringExp(Keys.title)
  
  let subtitle = TB.optStringExp(Keys.subtitle)
  
  let originTitle = TB.optStringExp(Keys.originTitle)
  
  let publishedDate = TB.optStringExp(Keys.publishedDate)
  
  let publisher = TB.optStringExp(Keys.publisher)
  
  let isbn10 = TB.optStringExp(Keys.isbn10)
  
  let isbn13 = TB.optStringExp(Keys.isbn13)
  
  let image = TB.optStringExp(Keys.image)
  
  let binding = TB.optStringExp(Keys.binding)
  
  let authorIntroduction = TB.optStringExp(Keys.authorIntroduction)
  
  let catalog = TB.optStringExp(Keys.catalog)
  
  let pages = TB.optStringExp(Keys.pages)
  
  let summary = TB.optStringExp(Keys.summary)
  
  let price = TB.optStringExp(Keys.price)
}
