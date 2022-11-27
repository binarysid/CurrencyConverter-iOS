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
    func requestForDomainData()
}
final class APIWorker<T:APIClientProtocol>:NetWorkerProtocol{
    var publisher = PassthroughSubject<[DomainRate], API.ErrorType>()
    var apiRepository:T?
    var subscriptions = Set<AnyCancellable>()
    init(client:T) {
        self.apiRepository = client
    }
    func requestForDomainData(){
        guard let url = API.EndPoints.allCurrencies(AppConstants.Config.APPID).url else{
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = API.HTTPMethods.GET
        apiRepository?.getData(urlRequest)
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
                self?.publisher.send(data)
                self?.publisher.send(completion: .finished)
            })
            .store(in: &subscriptions)
    }
}
