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
  
  private lazy  var fetchedCompletionsController: NSFetchedResultsController<Completion> = {
    let request = Completion.createFetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "completionDate", ascending: true)]
    return NSFetchedResultsController(fetchRequest: request,
                                      managedObjectContext: container.viewContext,
                                      sectionNameKeyPath: nil,
                                      cacheName: nil)
  }()
  
  private lazy var fetchedDisciplinesController: NSFetchedResultsController<Discipline> = {
    let request = Discipline.createFetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
    return NSFetchedResultsController(fetchRequest: request,
                                      managedObjectContext: container.viewContext,
                                      sectionNameKeyPath: nil,
                                      cacheName: nil)
  }()
  
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
    
    loadDisciplines()
    loadAllCompletions()
    removeSavedDisciplines()
    removeSavedCompletions()
    insertDummyData()
    loadDisciplines()
  }
  
  func loadAllCompletions(completion: (([Completion]) -> Void)? = nil) {
    performFetchCompletions(completion: completion)
  }
  
  func loadCompletions(daysBefore: Int, completion: (([Completion]) -> Void)? = nil) {
    let xDaysBefore = Calendar.current.startOfDay(for: Date()) - TimeInterval(daysBefore * 86400)
    fetchedCompletionsController.fetchRequest.predicate = NSPredicate(format: "completionDate >= %@",  argumentArray: [xDaysBefore])
    performFetchCompletions(completion: completion)
  }
  
  func loadCompletions(forDiscipline discipline: Discipline,
                       completion: @escaping ([Completion]) -> Void) {
    fetchedCompletionsController.fetchRequest.predicate = NSPredicate(format: "discipline == %@",  argumentArray: [discipline])
  }
  
  private func performFetchCompletions(completion: (([Completion]) -> Void)?) {
    do {
      try fetchedCompletionsController.performFetch()
    } catch {
      print("Fetch completion failed")
    }
    completion?(fetchedCompletionsController.fetchedObjects ?? [])
  }
  
  private func loadDisciplines() {
    do {
      try fetchedDisciplinesController.performFetch()
    } catch {
      print("Fetch disciplines failed")
    }
  }
  
  func removeSavedDisciplines() {
    getAllDisciplines().forEach {
      container.viewContext.delete($0)
    }
    do {
      try container.viewContext.save()
    } catch {
      fatalError("Could not save context")
    }
  }
  
  func removeSavedCompletions() {
    getAllCompletions().forEach {
      container.viewContext.delete($0)
    }
  }
  
  func insertDummyData() {
    initial.forEach { (text) in
      create(text, completion: nil)
    }
  }
  
  func create(_ disciplineText: String,
              customCreationDate: Date = Date(),
              completion: ((Discipline) -> Void)? = nil) {
    let discipline = Discipline(context: container.viewContext)
    discipline.dateIntroduced = customCreationDate
    discipline.shortText = disciplineText
    discipline.isArchived = false
    discipline.order = 1
    saveContext()
    completion?(discipline)
  }
  
  func complete(discipline: Discipline,
                customCompletion: Date = Date(),
                onComplete: (() -> Void)? = nil) {
    let completion = Completion(context: container.viewContext)
    completion.completionDate = customCompletion
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
    loadDisciplines()
    return fetchedDisciplinesController.fetchedObjects ?? []
  }
  
  func getAllCompletions() -> [Completion] {
    loadAllCompletions()
    return fetchedCompletionsController.fetchedObjects ?? []
  }
}
