//
//  ManagedFeedImage+CoreDataProperties.swift
//  EssentialFeed
//
//  Created by Davit Nahapetyan on 2024-01-22.
//
//

import CoreData

extension ManagedFeedImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedFeedImage> {
        return NSFetchRequest<ManagedFeedImage>(entityName: "ManagedFeedImage")
    }

    @NSManaged public var id: UUID
    @NSManaged public var imageDescription: String?
    @NSManaged public var location: String?
    @NSManaged public var url: URL
    @NSManaged public var cache: ManagedCache

    static func images(from localFeed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localFeed.map { local in
            let managed = ManagedFeedImage(context: context)
            managed.id = local.id
            managed.imageDescription = local.description
            managed.location = local.location
            managed.url = local.url
            return managed
        })
    }

    var local: LocalFeedImage {
        return LocalFeedImage(id: id, description: imageDescription, location: location, url: url)
    }
}

extension ManagedFeedImage : Identifiable {

}
