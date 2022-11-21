//
//  PersistenceRepository.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 13/10/22.
//


import CoreData
import Combine

protocol CustomError:Error{
    var notFound:Self{get}
    var duplicate:Self{get}
}
enum RepositoryError: CustomError {
    case notFound
    case duplicate
    case invalidManagedObjectType
    
    var notFound: RepositoryError{
        .notFound
    }
    
    var duplicate: RepositoryError{
        .duplicate
    }
    
    
}
protocol EntityCreating{
    var context:NSManagedObjectContext { get }
    func createEntity<T:NSManagedObject>()->T
}
extension EntityCreating{
    func createEntity<T:NSManagedObject>()->T{
        return T(context: context)
    }
}
protocol CoreDataCreateModelPublishing {
    var context: NSManagedObjectContext { get }
    func producer(save action: @escaping Action) -> CDSaveModelPublisher
}

extension CoreDataCreateModelPublishing {
    func producer(save action: @escaping Action) -> CDSaveModelPublisher {
        return CDSaveModelPublisher(action: action, context: context)
    }
}
protocol PersistenceStoring:EntityCreating,CoreDataCreateModelPublishing,RepositoryProtocol{
    
}
//class PersistenceRepository {
//
//    @discardableResult
//    func create(name:String, rate: Double)->Currency {
//        let currency = Currency(context: self.context)
//        currency.name = name
//        currency.rate = rate
//        PersistenceService.saveContext()
//        return currency
//    }
//
//}

class PersistenceRepository:PersistenceStoring{
    
    typealias Request = NSFetchRequest<Currency>
    typealias Output = CDFetchResultPublisher<Currency>
    var context: NSManagedObjectContext{
        return PersistenceService.context
    }
    func getData(_ request: NSFetchRequest<Currency>) -> CDFetchResultPublisher<Currency> {
        return CDFetchResultPublisher(request: request, context: context)
    }

//    func getData(completionHandler: @escaping (Result<[Currency]?, Error>) -> Void) {
//        let fetchRequest = Currency.fetchRequest()
//        do {
//            if let fetchResults = try context.fetch(fetchRequest) as? [Currency],fetchResults.count>0 {
//                completionHandler(.success(fetchResults))
//            } else {
//                completionHandler( .failure(RepositoryError.notFound))
//            }
//        } catch {
//            completionHandler( .failure(RepositoryError.invalidManagedObjectType))
//        }
//    }
}
// MARK: update data in background
extension PersistenceRepository{
    static func update(name:String,rate:Double,completionHandler:(RepositoryError?) -> Void){
        
        let filter = NSPredicate(format: "name == %@", name)
        let fetchRequest:NSFetchRequest<Currency> = Currency.fetchRequest()
        fetchRequest.predicate = filter
        do {
            let result = try PersistenceService.context.fetch(fetchRequest) as [Currency]
            if result.count>0, let data = result.first{
                data.rate = rate
                completionHandler(nil)
            }
            else{
                completionHandler(.notFound)
            }
        }
        catch{
            completionHandler(.notFound)
            return
        }
        PersistenceService.saveContext()
        completionHandler(nil)
    }
}

extension PersistenceRepository{
    func mapUserObj(persons:[Currency])->[DomainRate]{
        return persons.map({
            $0.toDomainModel()
        })
    }
}
