//
//  NewsTableViewModel.swift
//  tochka_test
//
//  Created by Станислав Коцарь on 29/07/2019.
//  Copyright © 2019 Станислав Коцарь. All rights reserved.
//

import Foundation

protocol NewsTableViewModelDelegate: class {
    func updateTableView ()
}

class NewsTableViewModel {
    
    var localService: LocalService!
    weak var delegate: NewsTableViewModelDelegate?
    var articles: [Article] = []
    var query = ""
    var page = 1
    
    required init() {
        
    }

    convenience init(delegate: NewsTableViewModelDelegate) {
        self.init()
        self.delegate = delegate
        localService = LocalService(delegate: self)
    }
    
}

extension NewsTableViewModel: LocalServiceDelegate {
    func articlesDidChanged() {
        guard let articles = localService.fetchArticles(with: query) else { return }
        self.articles = articles
        delegate?.updateTableView()
    }
}
