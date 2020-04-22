//
//  DataManager.swift
//  Disciplines
//
//  Created by Kevin Peng on 2020-04-19.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import CoreData

class DataManager {
  static let shared = DataManager()
  private var container: NSPersistentContainer!
  var fetchedResultsController: NSFetchedResultsController<Discipline>!
  let initial = ["Sleep at 9:30PM",
                 "Wake up at 4:30AM",
                 "Learn from any online resource whenever bored",
                 "Max 1 Overwatch game a day",
                 "Max 1 hour of music listening a day"]
  
  private init() {
    container = NSPersistentContainer(name: "Disciplines")
    container.loadPersistentStores { (storeDescription, error) in
      self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
      
      if let error = error {
        print("Unresolved error: \(error)")
      }
    }
    
    loadSavedData()
    removeSavedData()
    insertDummyData()
    loadSavedData()
  }
  
  private func loadSavedData() {
    if fetchedResultsController == nil {
      let request = Discipline.createFetchRequest()
      request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
      fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                            managedObjectContext: container.viewContext,
                                                            sectionNameKeyPath: nil,
                                                            cacheName: nil)
    }
    
    do {
      try fetchedResultsController.performFetch()
    } catch {
      print("Fetch failed")
    }
  }
  
  func removeSavedData() {
    getAllDisciplines().forEach {
      container.viewContext.delete($0)
    }
    do {
      try container.viewContext.save()
    } catch {
      fatalError("Could not save context")
    }
  }
  
  func insertDummyData() {
    initial.forEach { (text) in
      create(text, completion: nil)
    }
  }
  
  func create(_ disciplineText: String, completion: ((Discipline) -> Void)? = nil) {
    let discipline = Discipline(context: container.viewContext)
    discipline.dateIntroduced = Date()
    discipline.shortText = disciplineText
    discipline.isArchived = false
    discipline.order = 1
    saveContext()
    completion?(discipline)
  }
  
  func complete(discipline: Discipline, onComplete: (() -> Void)? = nil) {
    let completion = Completion(context: container.viewContext)
    completion.completionDate = Date()
    completion.discipline = discipline
    saveContext()
    onComplete?()
  }
  
  func delete(discipline: Discipline, onComplete: (() -> Void)? = nil) {
    container.viewContext.delete(discipline)
    saveContext()
    onComplete?()
  }
  
  func removeCompletion(discipline: Discipline) {
    discipline.completion = nil
    saveContext()
  }
  
  private func saveContext() {
    if container.viewContext.hasChanges {
      do {
        try container.viewContext.save()
      } catch {
        print("An error occured during saving: \(error)")
      }
    }
  }
  
  func getAllDisciplines() -> [Discipline] {
    fetchedResultsController.fetchedObjects!
  }
  
  func discipline(at row: Int) -> Discipline {
    let result = fetchedResultsController.object(at: IndexPath(row: row, section: 0))
    return result
  }
  
  func numberOfItems() -> Int {
    fetchedResultsController.sections?.first?.objects?.count ?? 0
  }
}
