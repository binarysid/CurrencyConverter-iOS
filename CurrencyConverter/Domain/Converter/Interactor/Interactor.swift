//
//  Interactor.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 8/10/22.
//

import Foundation

protocol ConverterInteractorProtocol{
    func getCurrencyList()
    func getConvertedList(by currency:String,amount:Double,data:[DomainRate]?)
}

//Interactor gets the request from view and connects with worker to fetch data and passes the output to presenter
class Interactor{
    var presenter:ConverterPresentationLogic?
    var currencyList:[Currency]?
    var apiRepository = APIRepository()
    var peresistenceRepository = PersistenceRepository()
}
// this is the CPU/Brain of the app.The role of the interactor is mainly the computation part of a scene. This is where you would fetch data (network or local), detect errors, make calculations, compute entries.
//This is the “mediator” between the Worker and the Presenter. Here is how the Interactor works. First, it communicates with the ViewController which passes all the Request params needed for the Worker. Before proceeding to the Worker, a validation is done to check if everything is sent properly. The Worker returns a response and the Interactor passes that response towards the Presenter.
//The Interactor also contains two types of protocols like the Router:
//Business Logic Protocol - declare all the Interactor methods in this protocol, so they can be available for use in the ViewController.
//Data Store Protocol - all properties that should keep their current state are declared here. This protocol is mainly used in the Router to pass data between controllers.
extension Interactor:ConverterInteractorProtocol{
    func getCurrencyList() {
        self.peresistenceRepository.getData(){result in
            switch result{
                case .success(let currData):
                    guard let data = currData else{
                        self.fetchFromAPI()// if no local data exists then fetch data from API
                        return
                    }
                    self.currencyList = data
                    self.presenter?.presentCurrencyListBy(currList: data)
                case .failure(_): // if no local data exists then fetch data from API
                    self.fetchFromAPI()
            }
        }
    }
    
    private func fetchFromAPI(){
        presenter?.showProgressLoader()
        apiRepository.getData(completionHandler: {result in
            switch result{
            case .success(let data):
                guard let data = data else{
                    self.presenter?.listFetchFailed()
                    return
                }
                self.presenter?.presentCurrencyListBy(data)
                self.saveToPersistenceRepoInBackground(data)
            case .failure(_):
                self.presenter?.listFetchFailed()
            }
            self.presenter?.hideProgressLoader()
        })
    }
    private func saveToPersistenceRepoInBackground(_ data:ExchangeRates){
        for (key,value) in data.rates{ self.peresistenceRepository.create(name: key, rate: value)
        }
    }
    func getConvertedList(by currency:String,amount:Double,data:[DomainRate]?){
        presenter?.presentConvertedList(data: self.getConvertedList(from: currency, amount: amount, data: data))
    }
    
}
// MARK: Currency Conversion
extension Interactor{
    private func getConvertedList(from currency:String,amount:Double,data:[DomainRate]?)->[DomainRate]{
        guard var data = data,let usdRate = data.first(where: { $0.currency == currency })?.rate else{return []}
        for (index,item) in data.enumerated(){
            let convertedRate = convert(givenCurrencyRateInUSD: usdRate, expectedCurrencyRateInUSD: item.rate, amount: amount)
            data[index].rate = convertedRate.rounding(to: 3)
        }
        return data
    }
    // from the API we only get 1 unit USD rate. so for converting from other currencies the formula is:
    // desiredRate = (totalAmount/USDRate)*expectedCurrencyRateInUSD
    func convert( givenCurrencyRateInUSD rate1:Double,expectedCurrencyRateInUSD rate2:Double,amount:Double)->Double{
        let amountInUSD = amount/rate1
        return (rate2*amountInUSD)
    }
}
// for update operation when app in background
extension Interactor{
    static func updatePersistenceStore(completionHandler: @escaping(RepositoryError?) -> Void){
        let repository = APIRepository()
        repository.getData(completionHandler: {result in
            switch result{
            case .success(let data):
                guard let data = data else{
                    completionHandler(.notFound)
                    return
                }
                for (key,value) in data.rates{
                    PersistenceRepository.update(name: key, rate: value){ response in
                        if response == nil{
                            print("successfully updated")
                        }
                    }
                }
            case .failure(_):
                completionHandler(.notFound)
            }
        })
    }

}
