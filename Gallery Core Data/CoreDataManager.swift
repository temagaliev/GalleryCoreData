//
//  CoreDataManager.swift
//  Gallery Core Data
//
//  Created by Artem Galiev on 31.10.2023.
//

import CoreData
import UIKit

public final class CoreDataManager: NSObject {
    
    public static let shared = CoreDataManager()
    private override init(){}
    
    private let constants = Constants()
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    public func createPhoto(_ imageData: Data) {
        guard let photoEntityDescription = NSEntityDescription.entity(forEntityName: constants.photoName, in: context) else {
            return
        }
        let photo = Photo(entity: photoEntityDescription, insertInto: context)
        photo.imageData = imageData
        appDelegate.saveContext()
    }
    
    public func fetchPhotos() -> [Photo] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: constants.photoName)
        do {
            return try context.fetch(fetchRequest) as! [Photo]
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    public func deleteAllPhoto() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: constants.photoName)
        do {
            let photos = try? context.fetch(fetchRequest) as? [Photo]
            photos?.forEach {context.delete($0)}
        }
        appDelegate.saveContext()
    }
    
    public func deletePhoto(with imageData: Data) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: constants.photoName)
        do {
            guard let photos = try? context.fetch(fetchRequest) as? [Photo],
                  let photo = photos.first(where: {$0.imageData == imageData}) else {return}
            context.delete(photo)
        }
        appDelegate.saveContext()
    }
}

private extension CoreDataManager {
    private struct Constants {
        let photoName: String = "Photo"
    }
}
