//
//  APIClient.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 9/10/22.
//

import Foundation
import Combine

class APIRepository{
    enum ResponseCode:Int{
        case success = 200
        case failed = 404
    }
    typealias completionHandler = (Result<ExchangeRates?,Error>)->Void
    // this funciton defines generic structure for network calls so it can be reused for all async operation
    func executeAsync(_ urlRequest:URLRequest, completionHandler: @escaping resultHandler){
        let urlSession = URLSession.shared
        let dataTask = urlSession.dataTask(with: urlRequest){ data,response,error in
            guard let responseStatus = response as? HTTPURLResponse, responseStatus.statusCode == ResponseCode.success.rawValue else{
                completionHandler(.failure(API.ErrorType.Service))
                return
            }
            guard let data = data, error == nil else{
                completionHandler(.failure(API.ErrorType.Service))
                return
            }
            completionHandler(.success(data))
        }
        dataTask.resume()
    }
}
extension APIRepository:RepositoryProtocol{
    typealias Request = URLRequest
    typealias Output = AnyPublisher<ExchangeRates, Error>

    func getData(_ request:URLRequest) -> AnyPublisher<ExchangeRates, Error> {
        URLSession.shared.dataTaskPublisher(for: request)
            .map({ $0.data })
            .decode(type: ExchangeRates.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
//    func getData(completionHandler: @escaping(Result<ExchangeRates?, Error>) -> Void) {
//        self.fecthCurrencyList(completionHandler: {result in
//            switch result{
//            case .success(let data):
//                if let data = data{
//                    do{
//                        let resultData = try JSONDecoder().decode(ExchangeRates.self, from: data)
//                        completionHandler(.success(resultData))
//                    }catch(_){
//                        completionHandler(.failure(API.ErrorType.NoDataFound))
//                    }
//                }
//                else{
//                    completionHandler(.failure(API.ErrorType.NoDataFound))
//                }
//            case .failure(let error):
//                completionHandler(.failure(error))
//            }
//        })
//    }
}
extension APIRepository:APIClientProtocol{
    func fecthCurrencyList(completionHandler: @escaping resultHandler){
        guard let url = API.EndPoints.allCurrencies(AppConstants.Config.APPID).url else{
                completionHandler(.failure(API.ErrorType.BadURL))
                return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = API.HTTPMethods.GET
        executeAsync(urlRequest, completionHandler: {result in
            switch result {
                case .success(let data):
                    if let data = data{
                        completionHandler(.success(data))
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
            }
        })
    }

}
