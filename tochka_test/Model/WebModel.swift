//
//  WebModel.swift
//  tochka_test
//
//  Created by Станислав Коцарь on 28/07/2019.
//  Copyright © 2019 Станислав Коцарь. All rights reserved.
//

import Foundation

struct WebModel: Decodable {
    let totalResults: Int
    let articles: [ArticleData]
}
