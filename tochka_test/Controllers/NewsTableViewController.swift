//
//  ViewController.swift
//  tochka_test
//
//  Created by Станислав Коцарь on 28/07/2019.
//  Copyright © 2019 Станислав Коцарь. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    var searchBar: UISearchController!
    var newsTableVM: NewsTableViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableVM = NewsTableViewModel(delegate: self)
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsTableViewCell")
        addSearchBarInNavigationController()
        newsTableVM.localService.fetchArticlesFromServer(with: newsTableVM.page)
    }
    
    
    
    func addSearchBarInNavigationController () {
        title = "Title"
        searchBar = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchBar
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsTableVM.articles.count
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
     let index = indexPath.row
     cell.titleLabel.text = newsTableVM.articles[index].title
     cell.descriptionLabel.text = newsTableVM.articles[index].descript
     return cell
     }
    
}


extension NewsTableViewController: NewsTableViewModelDelegate {
    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
