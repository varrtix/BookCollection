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

import UIKit

struct BCMapping {
  enum ViewControllers: String {
    enum TabBar: String, CaseIterable {
      case collections = "Collections"
      case me = "Me"
      
      var raw: UIViewController {
        switch self {
          case .collections: return BCListViewController()
          case .me: return BCAnalyticViewController()
        }
      }
      var identifier: String { self.rawValue }
    }
    
    case scan = "Scan"

    case tableList = "TableList"
    case collectionList = "CollectionList"

    var raw: UIViewController {
      switch self {
        case .scan: return BCScanViewController()
        case .tableList: return BCListTableViewController()
        case .collectionList: return BCListCollectionViewController()
      }
    }
    
    var identifier: String { self.rawValue }
  }
  
  enum CellIdentifier: String {
    case listTableView = "BCListTableViewCell"
    case listCollectionView = "BCListCollectionViewCell"
  }
}

struct BCColor {
  enum BarTint {
    static let green = UIColor(HEX: 0x009D82)
    static let white = UIColor(R: 245, G: 245, B: 245)
    static let gray = UIColor.darkGray
  }
  
  enum ListTint {
    static let snowWhite = UIColor(HEX: 0xF9F9F9)
  }
}

let screenSize = UIScreen.main.bounds.size
