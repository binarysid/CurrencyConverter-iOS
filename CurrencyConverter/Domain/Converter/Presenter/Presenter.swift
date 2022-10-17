//
//  Presenter.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 8/10/22.
//

import Foundation

protocol ConverterPresentationLogic:LoaderProtocol{
    func presentConvertedList(data:[DomainRate])
    func presentCurrencyListBy(_ data:ExchangeRates?)
    func presentCurrencyListBy(currList:[Currency]?)
    func convertToViewModel(data:Currency)->DomainRate
    func listFetchFailed()
}

//Presenter is triggered by the interactor with some results. Then it process the response into view models suitable for display.
class Presenter{
    var view: ConverterViewLogic?
}
extension Presenter:ConverterPresentationLogic{
    func presentCurrencyListBy(_ data: ExchangeRates?) {
        guard let data = data else {
            return
        }
        var domainRates:[DomainRate] = []
        for (key,value) in data.rates{
            let rateObj = DomainRate(currency: key, rate: value)
            domainRates.append(rateObj)
        }
        self.view?.showCurrencyList(domainRates)
    }
    
    func presentCurrencyListBy(currList: [Currency]?) {
        guard let data = currList else {return}
        var domainRates:[DomainRate] = []
        for currency in data{
            domainRates.append(currency.toDomainModel())
        }
        domainRates = self.sortAlphabetically(data: domainRates)
        self.view?.showCurrencyList(domainRates)
    }
    
    func convertToViewModel(data:Currency)->DomainRate{
        return data.toDomainModel()
    }
    func listFetchFailed(){
        self.view?.showCurrencyFetchError()
    }
    func presentConvertedList(data:[DomainRate]) {
        self.view?.showConvertedRates(data)
    }
    func showProgressLoader() {
        view?.showProgressLoader()
    }
    
    func hideProgressLoader() {
        view?.hideProgressLoader()
    }
}
extension Presenter{
    private func sortAlphabetically(data:[DomainRate])->[DomainRate]{
        return data.sorted { $0.currency < $1.currency }
    }
}

