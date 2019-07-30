//
//  ViewController.swift
//  tochka_test
//
//  Created by Станислав Коцарь on 28/07/2019.
//  Copyright © 2019 Станислав Коцарь. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    var searchBarVC: UISearchController!
    var newsTableVM: NewsTableViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableVM = NewsTableViewModel(delegate: self)
        configureTableView()
        addSearchBarInNavigationController()
        newsTableVM.fetchNewArticles()
    }
    
    func configureTableView () {
        tableView.isHidden = true
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        tableView.prefetchDataSource = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsTableViewCell")
    }
    
    
    
    func addSearchBarInNavigationController () {
        title = "News app"
        searchBarVC = UISearchController(searchResultsController: nil)
        searchBarVC.searchBar.delegate = self
        
        searchBarVC.definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchBarVC
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsTableVM.totalRows
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
     let index = indexPath.row
        if isLoadingCell(for: indexPath) {
            
        } else {
            cell.delegate = self
            cell.titleLabel.text = newsTableVM.articles[index].title
            cell.descriptionLabel.text = newsTableVM.articles[index].descript
        }
     return cell
     }
    
    
    
}


extension NewsTableViewController: NewsTableViewModelDelegate {
    func updateTableView(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            tableView.isHidden = false
            tableView.reloadData()
            return
        }
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
}


extension NewsTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarVC.dismiss(animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        newsTableVM.query = searchBar.text!
        newsTableVM.articlesDidChanged(totalRows: nil)
    }
}

extension NewsTableViewController: NewsTableViewCellDelegate {
    func didTappOnImageButton(cell: UITableViewCell) {
        let index = self.tableView.indexPath(for: cell)!.row
        let string = newsTableVM.articles[index].imageUrl
        guard let url = URL(string: string!) else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    
}

extension NewsTableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            newsTableVM.fetchNewArticles()
        }
    }
}

private extension NewsTableViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= newsTableVM.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
