//
//  PageIntro.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 23.06.2023.
//

import SwiftUI

struct PageIntro: Identifiable, Hashable {
    var id: UUID = .init()
    var introAssetImage: String
    var title: String
    var subTitle: String
    var displaysAction: Bool = false
}
