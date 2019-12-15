//
//  SectionOfCustomData.swift
//  Backpacr
//
//  Created by joon-ho kil on 2019/12/13.
//  Copyright © 2019 joon-ho kil. All rights reserved.
//

import Foundation
import RxDataSources

struct SectionOfCustomData {
  var header: String
  var items: [Item]
}
extension SectionOfCustomData: SectionModelType {
  typealias Item = Body

   init(original: SectionOfCustomData, items: [Item]) {
    self = original
    self.items = items
  }
}

struct DetailSectionOfCustomData {
  var header: String
  var items: [Item]
}
extension DetailSectionOfCustomData: SectionModelType {
  typealias Item = String

   init(original: DetailSectionOfCustomData, items: [Item]) {
    self = original
    self.items = items
  }
}
