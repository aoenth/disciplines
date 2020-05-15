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
    
    removeSavedDisciplines()
    removeSavedCompletions()
    insertDummyData()
  }
  
  func loadAllCompletions() -> [Completion] {
    return performFetchCompletions()
  }
  
  func loadCompletions(daysBefore: Int, showArchived: Bool = true) -> [Completion] {
    let xDaysBefore = Calendar.current.startOfDay(for: Date()) - TimeInterval(daysBefore * 86400)
    let predicate: NSPredicate
    if showArchived == false {
      let completionPredicate = NSPredicate(format: "completionDate >= %@", argumentArray: [xDaysBefore])
      let archivePredicate = NSPredicate(format: "discipline.isArchived == false")
      predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [completionPredicate, archivePredicate])
    } else {
      predicate = NSPredicate(format: "completionDate >= %@",  argumentArray: [xDaysBefore])
    }
    fetchedCompletionsController.fetchRequest.predicate = predicate
    return performFetchCompletions()
  }
  
  func loadCompletions(forDiscipline discipline: Discipline) -> [Completion] {
    fetchedCompletionsController.fetchRequest.predicate = NSPredicate(format: "discipline == %@",  argumentArray: [discipline])
    return performFetchCompletions()
  }
  
  func loadDisciplines(showArchived: Bool) -> [Discipline] {
    if showArchived == false {
      fetchedDisciplinesController.fetchRequest.predicate = NSPredicate(format: "isArchived == %@", argumentArray: [false])
    } else {
      fetchedDisciplinesController.fetchRequest.predicate = nil
    }
    return performFetchDiscipline()
  }
  
  private func performFetchCompletions() -> [Completion] {
    do {
      try fetchedCompletionsController.performFetch()
    } catch {
      print("Fetch completion failed")
    }
    return fetchedCompletionsController.fetchedObjects ?? []
  }
  
  private func performFetchDiscipline() -> [Discipline] {
    do {
      try fetchedDisciplinesController.performFetch()
    } catch {
      print("Fetch disciplines failed")
    }
    return fetchedDisciplinesController.fetchedObjects ?? []
  }
  
  
  func removeSavedDisciplines() {
    getAllDisciplines().forEach {
      container.viewContext.delete($0)
    }
  }
  
  func removeSavedCompletions() {
    getAllCompletions().forEach {
      container.viewContext.delete($0)
    }
  }
  
  func insertDummyData() {
    initial.forEach { (text) in
      _ = create(text)
    }
  }
  
  func create(_ disciplineText: String, customCreationDate: Date = Date()) -> Discipline {
    let discipline = Discipline(context: container.viewContext)
    discipline.dateIntroduced = customCreationDate
    discipline.shortText = disciplineText
    discipline.isArchived = false
    discipline.order = 1
    return discipline
  }
  
  func complete(discipline: Discipline,
                customCompletion: Date = Date(),
                onComplete: (() -> Void)? = nil) {
    guard !discipline.isCompletedForToday else {
      return
    }
    let completion = Completion(context: container.viewContext)
    completion.completionDate = customCompletion
    completion.discipline = discipline
    saveContext()
    onComplete?()
  }
  
  func delete(discipline: Discipline) {
    container.viewContext.delete(discipline)
  }
  
  func archive(discipline: Discipline) {
    discipline.isArchived = true
    saveContext()
  }
  
  func removeCompletion() {
    loadCompletions(daysBefore: 0).forEach {
      container.viewContext.delete($0)
    }
  }
  
  func saveContext() {
    if container.viewContext.hasChanges {
      do {
        try container.viewContext.save()
      } catch {
        print("An error occured during saving: \(error)")
      }
    }
  }
  
  func getActiveDisciplines() -> [Discipline] {
    return loadDisciplines(showArchived: false)
  }
  
  func getAllDisciplines() -> [Discipline] {
    return loadDisciplines(showArchived: true)
  }
  
  func getAllCompletions() -> [Completion] {
    return loadAllCompletions()
  }
}
