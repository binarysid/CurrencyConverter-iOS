//
//  APIWorker.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 6/11/22.
//

import Foundation
import Combine

protocol NetWorkerProtocol{
    var publisher:PassthroughSubject<[DomainRate], API.ErrorType>{
        get set
    }
    func getDomainData()
}
class APIWorker:NetWorkerProtocol{
    var publisher = PassthroughSubject<[DomainRate], API.ErrorType>()
    var apiRepository = APIRepository()
    var subscriptions = Set<AnyCancellable>()
    func getDomainData(){
        guard let url = API.EndPoints.allCurrencies(AppConstants.Config.APPID).url else{
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = API.HTTPMethods.GET
        apiRepository.getData(urlRequest)
            .map{
                $0.rates.map{key,value in
                    DomainRate(currency: key, rate: value)
                }
            }
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(_) = completion{
                    self?.publisher.send(completion: .failure(.NoDataFound))
                }
                
            }, receiveValue: {[weak self] data in
//                var domainRates:[DomainRate] = []
//                for (key,value) in data.rates{
//                    let rateObj =
//                    domainRates.append(rateObj)
//                }
                self?.publisher.send(data)
                self?.publisher.send(completion: .finished)
//                self?.saveToPersistenceRepoInBackground(data)
            })
            .store(in: &subscriptions)
    }
}

//extension APIWorker{
//    private func saveToPersistenceRepoInBackground(_ data:[String: Double]){
//        for (key,value) in data{ self.peresistenceRepository.create(name: key, rate: value)
//        }
//    }
//}
