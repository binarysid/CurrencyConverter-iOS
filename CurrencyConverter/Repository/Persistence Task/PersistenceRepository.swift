//
//  PersistenceRepository.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 13/10/22.
//


import CoreData

enum RepositoryError: Error {
    case notFound
    case duplicate
    case invalidManagedObjectType
}
class PersistenceRepository {
    private let context = PersistenceService.context
    
    @discardableResult
    func create(name:String, rate: Double)->Currency {
        let currency = Currency(context: self.context)
        currency.name = name
        currency.rate = rate
        PersistenceService.saveContext()
        return currency
    }
    
}

extension PersistenceRepository:RepositoryProtocol{
    typealias T = [Currency]
    func getData(completionHandler: @escaping (Result<[Currency]?, Error>) -> Void) {
        let fetchRequest = Currency.fetchRequest()
        do {
            if let fetchResults = try context.fetch(fetchRequest) as? [Currency],fetchResults.count>0 {
                completionHandler(.success(fetchResults))
            } else {
                completionHandler( .failure(RepositoryError.notFound))
            }
        } catch {
            completionHandler( .failure(RepositoryError.invalidManagedObjectType))
        }
    }
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
