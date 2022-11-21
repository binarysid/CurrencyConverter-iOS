//
//  CDSaveModelPublisher.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 18/11/22.
//

import Combine
import CoreData

typealias Action = (()->())
struct CDSaveModelPublisher:Publisher{
    typealias Output = Bool
    typealias Failure = RepositoryError
    private let action: Action
    private let context: NSManagedObjectContext
    
    init(action: @escaping Action, context: NSManagedObjectContext) {
        self.action = action
        self.context = context
    }
    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = Subscription(subscriber: subscriber, context: context, action: action)
        subscriber.receive(subscription: subscription)
    }
    
}

extension CDSaveModelPublisher{
    class Subscription<S> where S:Subscriber, Failure == S.Failure, Output == S.Input{
        private var subscriber: S?
        private let action: Action
        private let context: NSManagedObjectContext
        
        init(subscriber: S, context: NSManagedObjectContext, action: @escaping Action) {
            self.subscriber = subscriber
            self.context = context
            self.action = action
        }
    }
}

extension CDSaveModelPublisher.Subscription:Subscription{
    func cancel() {
        subscriber = nil
    }
    
    func request(_ demand: Subscribers.Demand) {
        var demand = demand
        guard let subscriber = subscriber, demand > 0 else {
            subscriber?.receive(completion: .failure(.invalidManagedObjectType))
            return
        }
        action()
        PersistenceService.saveContext()
        demand -= 1
        demand += subscriber.receive(true)
        subscriber.receive(completion: .finished)
    }
}
