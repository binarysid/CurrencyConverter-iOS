//
//  APIClient.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 9/10/22.
//

import Foundation

class APIRepository{
    enum APIError:Error{
        case serviceError
        case badURL
        case noDataFound
    }
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
                completionHandler(.failure(APIError.serviceError))
                return
            }
            guard let data = data, error == nil else{
                completionHandler(.failure(APIError.serviceError))
                return
            }
            completionHandler(.success(data))
        }
        dataTask.resume()
    }
}
extension APIRepository:RepositoryProtocol{
    typealias T = ExchangeRates
    func getData(completionHandler: @escaping(Result<ExchangeRates?, Error>) -> Void) {
        self.fecthCurrencyList(completionHandler: {result in
            switch result{
            case .success(let data):
                if let data = data{
                    do{
                        let resultData = try JSONDecoder().decode(ExchangeRates.self, from: data)
                        completionHandler(.success(resultData))
                    }catch(_){
                        completionHandler(.failure(APIError.noDataFound))
                    }
                }
                else{
                    completionHandler(.failure(APIError.noDataFound))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        })
    }
}
extension APIRepository:APIClientProtocol{
    func fecthCurrencyList(completionHandler: @escaping resultHandler){
        
        guard var urlComponents = URLComponents(string: AppConstants.RestURL.currencyParser) else{
            completionHandler(.failure(APIError.badURL))
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "app_id", value: AppConstants.Config.APPID)
        ]
        guard let url = urlComponents.url else{
            completionHandler(.failure(APIError.badURL))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = AppConstants.HTTPMethods.GET
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
