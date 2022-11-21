//
//  CDFetchResultPublisher.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 17/11/22.
//

import Combine
import CoreData

struct CDFetchResultPublisher<Entity>:Publisher where Entity: NSManagedObject{
    func receive<S>(subscriber: S) where S : Subscriber, API.ErrorType == S.Failure, [Entity] == S.Input {
        let subscription = Subscription(subscriber: subscriber,request: request, context: context)
        subscriber.receive(subscription: subscription)
    }
    
    typealias Output = [Entity]
    typealias Failure = API.ErrorType
    private let request: NSFetchRequest<Entity>
    private let context: NSManagedObjectContext
    
    init(request: NSFetchRequest<Entity>, context: NSManagedObjectContext) {
        self.request = request
        self.context = context
    }
}

extension CDFetchResultPublisher{
    class Subscription<S> where S:Subscriber, Failure == S.Failure, Output == S.Input{
        private var subscriber: S?
        private let request: NSFetchRequest<Entity>
        private let context: NSManagedObjectContext
        
        init(subscriber: S,request: NSFetchRequest<Entity>, context: NSManagedObjectContext) {
            self.subscriber = subscriber
            self.request = request
            self.context = context
        }
    }
}

extension CDFetchResultPublisher.Subscription:Subscription{
    func request(_ demand: Subscribers.Demand) {
        var demand = demand
        guard let subscriber = subscriber,demand>0 else {
    
            return
        }
        do {
            demand -= 1
            let items = try context.fetch(request)
            if items.count>0{
                demand += subscriber.receive(items)
            }
            else{
                subscriber.receive(completion: .failure(.NoDataFound))
            }
        } catch {
            subscriber.receive(completion: .failure(.Service))
        }
    }
}
extension CDFetchResultPublisher.Subscription: Cancellable {
    func cancel() {
        subscriber = nil
    }
}
