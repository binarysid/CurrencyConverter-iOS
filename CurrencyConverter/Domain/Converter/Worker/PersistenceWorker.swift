//
//  PersistenceWorker.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 6/11/22.
//

import Foundation
import Combine

protocol PersistenceWorkerProtocol{
    var publisher:PassthroughSubject<[DomainRate], API.ErrorType>{
        get set
    }
    func getDomainData()
    func saveCurrencyInBackground(_ data:[DomainRate])
}
class PersistenceWorker:PersistenceWorkerProtocol{
    
    var publisher = PassthroughSubject<[DomainRate], API.ErrorType>()
    var peresistenceRepository = PersistenceRepository()
    var subscriptions = Set<AnyCancellable>()
    func getDomainData() {
        let fetchRequest = Currency.fetchRequest()
        self.peresistenceRepository.getData(fetchRequest)
            .map{
                $0.map{ data in
                    data.toDomainModel()
                }
            }
            .sink(receiveCompletion: {[weak self] completion in
                if case .failure(_) = completion{
                    self?.publisher.send(completion: .failure(.NoDataFound))
                }
            }, receiveValue: {[weak self] data in
                self?.publisher.send(data)
                self?.publisher.send(completion: .finished)
            })
            .store(in: &subscriptions)
    }
    func saveCurrencyInBackground(_ data: [DomainRate]) {
        for item in data{
            self.saveCurrency(name: item.currency, rate: item.rate)
        }
    }
}

extension PersistenceWorker{
    func saveCurrency(name:String, rate: Double){
        let action: Action = {
            let currency:Currency = self.peresistenceRepository.createEntity()
            currency.name = name
            currency.rate = rate
        }
        let _ = self.peresistenceRepository.producer(save: action)
            .sink(receiveCompletion: {completion in
                print(completion)
            }, receiveValue: { val in
                print(val)
            })
    }
}
