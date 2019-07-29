//
//  Article+CoreDataProperties.swift
//  tochka_test
//
//  Created by Станислав Коцарь on 29/07/2019.
//  Copyright © 2019 Станислав Коцарь. All rights reserved.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var descript: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var title: String?

}
