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

struct BCDatabase {
  static var directoryURL: URL {
    URL(
      fileURLWithPath: "BCDB",
      relativeTo: FileManager.documentDirectoryURL)
  }
  
  static var fileURL: URL {
    URL(
      fileURLWithPath: "Book.sqlite",
      relativeTo: directoryURL)
  }
  
  static let queue = DispatchQueue(
    label: "com.varrtix.bcdatabase",
    qos: .background,
    attributes: .concurrent)
}

enum BCTable {
  case root, book, authors, translators
  case tags, images, series, ratings
  
  var rawName: String {
    switch self {
      case .root: fallthrough
      case .book: return "TB_BC_ROOT_BOOK"
      case .authors: return "TB_BC_AUTHORS"
      case .translators: return "TB_BC_TRANSLATORS"
      case .tags: return "TB_BC_TAGS"
      case .images: return "TB_BC_IMAGES"
      case .series: return "TB_BC_SERIES"
      case .ratings: return "TB_BC_RATINGS"
    }
  }
}
