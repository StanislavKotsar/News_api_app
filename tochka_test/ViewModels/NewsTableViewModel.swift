//
//  NewsTableViewModel.swift
//  tochka_test
//
//  Created by Станислав Коцарь on 29/07/2019.
//  Copyright © 2019 Станислав Коцарь. All rights reserved.
//

import Foundation

protocol NewsTableViewModelDelegate: class {
    func updateTableView (with newIndexPathsToReload: [IndexPath]?)
    
}

class NewsTableViewModel {
    
    var localService: LocalService!
    weak var delegate: NewsTableViewModelDelegate?
    var articles: [Article] = []
    var query = ""
    var page = 1
    var totalRows = 0
    var currentCount: Int {
        return articles.count
    }
    
    required init() {
        
    }

    convenience init(delegate: NewsTableViewModelDelegate) {
        self.init()
        self.delegate = delegate
        localService = LocalService(delegate: self)
    }
    
    func fetchNewArticles () {
        localService.fetchArticlesFromServer(with: page)
    }
    
    private func calculateIndexPathsToReload(from newArticles: [Article]) -> [IndexPath] {
        let startIndex = articles.count - newArticles.count
        let endIndex = startIndex + newArticles.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
}

extension NewsTableViewModel: LocalServiceDelegate {
    
    func articlesDidChanged(totalRows: Int?) {
        if let totalRows = totalRows {
            self.totalRows = totalRows
        }
        page += 1
        guard let articles = localService.fetchArticles(with: query) else { return }
        self.articles = articles
        if page > 2 {
            let indexPathsToReload = self.calculateIndexPathsToReload(from: articles)
            self.delegate?.updateTableView(with: indexPathsToReload)
        } else {
            self.delegate?.updateTableView(with: nil)
        }
    }
}
