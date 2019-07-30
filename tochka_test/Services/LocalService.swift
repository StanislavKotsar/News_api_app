//
//  LocalService.swift
//  tochka_test
//
//  Created by Станислав Коцарь on 29/07/2019.
//  Copyright © 2019 Станислав Коцарь. All rights reserved.
//

import UIKit
import CoreData

protocol LocalServiceDelegate: class {
    func articlesDidChanged (totalRows: Int?)
}

class LocalService {
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let remoteService = RemoteService()
    var delegate: LocalServiceDelegate?
    
    func fetchArticlesFromServer (with page: Int) {
        remoteService.loadArticles(page: page) { result in
            switch result {
            case .success(let result):
                self.handleSuccesResponse(result: result, page: page)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    required init() {
        
    }
    
    convenience init(delegate: LocalServiceDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    func handleSuccesResponse (result: WebModel, page: Int) {
        if page == 1 {
            updateArticles(articles: result.articles, totalRows: result.totalResults)
        } else {
            insertArticles(articles: result.articles, totalRows: result.totalResults)
        }
    }
    
    
    func updateArticles (articles: [ArticleData], totalRows: Int?) {
        deleteObjects()
        insertArticles(articles: articles, totalRows: totalRows)
    }
    
    func insertArticles(articles: [ArticleData], totalRows: Int?) {
        for remoteArticle in articles {
            let article = Article(entity: Article.entity(), insertInto: context)
            article.descript = remoteArticle.description
            article.title = remoteArticle.title
            article.imageUrl = remoteArticle.urlToImage
        }
        saveContext()
        DispatchQueue.main.async {
            self.delegate?.articlesDidChanged(totalRows: totalRows)
        }
    }
    
    func fetchArticles(with query: String) -> [Article]? {
        let request = Article.fetchRequest() as NSFetchRequest<Article>
        if !query.isEmpty {
            var compoundPredicate: [NSPredicate] = []
            compoundPredicate.append(NSPredicate(format: "title CONTAINS[cd] %@", query))
            compoundPredicate.append(NSPredicate(format: "descript CONTAINS[cd] %@", query))
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: compoundPredicate)
        }
        
        do {
            let articles = try context.fetch(request)
            return articles
        } catch let error as NSError {
            
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    private func deleteObjects () {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        let deleteRequest = NSBatchDeleteRequest( fetchRequest: fetchRequest)
        do{
            try context.execute(deleteRequest)
        }catch let error { print("failed to delete \(error)") }
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
}
