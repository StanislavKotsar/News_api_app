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
    func articlesDidChanged ()
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
            updateArticles(articles: result.articles)
        } else {
            insertArticles(articles: result.articles)
        }
        insertArticles(articles: result.articles)
    }
    
    
    func updateArticles (articles: [ArticleData]) {
        deleteObjects()
        insertArticles(articles: articles
        )
    }
    
    func insertArticles(articles: [ArticleData]) {
        for remoteArticle in articles {
            let article = Article(entity: Article.entity(), insertInto: context)
            article.descript = remoteArticle.description
            article.title = remoteArticle.title
            article.imageUrl = remoteArticle.urlToImage
        }
        saveContext()
        delegate?.articlesDidChanged()
    }
    
    func fetchArticles(with query: String) -> [Article]? {
        let request = Article.fetchRequest() as NSFetchRequest<Article>
        if !query.isEmpty {
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", query)
        }
        do {
            return try context.fetch(Article.fetchRequest())
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
