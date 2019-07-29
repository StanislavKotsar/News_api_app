//
//  ArticleData.swift
//  tochka_test
//
//  Created by Станислав Коцарь on 28/07/2019.
//  Copyright © 2019 Станислав Коцарь. All rights reserved.
//

import Foundation

struct ArticleData: Decodable {
    let title: String
    let description: String
    let urlToImage: String
}
