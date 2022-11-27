//
//  Injector.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 6/11/22.
//

import Swinject

@propertyWrapper
struct Inject<T>{
    let wrappedValue:T
    init(){
        self.wrappedValue = DIManager.shared.resolve(T.self)
    }
}


final class DIManager {
    static let shared = DIManager()
    private var container = Container()
    
    func resolve<T>(_ type: T.Type) -> T {
        container.resolve(T.self)!
    }
    func registerAPIWorker(){
        container.register(NetWorkerProtocol.self) { _  in
            return APIWorker()
        }
    }
    func registerPersistenceWorker(){
        container.register(PersistenceWorkerProtocol.self) { _  in
            return PersistenceWorker()
        }
    }
    func registerConversionWorker(){
        container.register(ConversionWorker.self) { _  in
            return ConversionWorker()
        }
    }
}

