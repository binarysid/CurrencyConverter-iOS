//
//  ViewModel.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 14/10/22.
//

import Foundation

protocol LoaderProtocol{
    func showProgressLoader()
    func hideProgressLoader()
}
protocol ConverterViewLogic:LoaderProtocol{
    func showConvertedRates(_ rates:[DomainRate])
    func showCurrencyList(_ currencies:[DomainRate])
    func showCurrencyFetchError()
}
// ViewModel is the class that our View interacts mostly to watch for data changes. Whenever the view model is updated, the view gets notified to update it's components. This class interacts with the Interactor to fetch the data
class ViewModel:ObservableObject{
    @Published var viewObject:[DomainRate] = []
    @Published var currencyRate:String = "1.00"{
        didSet{ // once the selected currency rate changes this will trigger the new calculation for currency rate
            guard let amount = Double(currencyRate) else{return}
            interactor?.getConvertedList(by: selectedCurrency, amount: amount,data:self.viewObject)
        }
    }
    @Published var selectedCurrency:String = ""{
        didSet{ // once the selected currency changes this will trigger the new calculation for currency rate
            guard let amount = Double(currencyRate) else{return}
            interactor?.getConvertedList(by: selectedCurrency, amount: amount,data:self.viewObject)
        }
    }
    @Published var showLoader = false
    var interactor:ConverterInteractorProtocol?
    init(){
        configure()
    }
    func currencyList(){
        interactor?.getCurrencyList()
    }
}
extension ViewModel:ConverterViewLogic{
    func showConvertedRates(_ rates:[DomainRate]) {
        DispatchQueue.main.async {
            self.viewObject = rates
        }
    }
    
    func showCurrencyList(_ currencies: [DomainRate]) {
        DispatchQueue.main.async {
            self.viewObject = currencies
            guard let data = self.viewObject.first(where: {$0.currency == "USD"}) else{return}
            self.selectedCurrency = data.currency
        }
    }
    func showCurrencyFetchError(){
        
    }
    func showProgressLoader(){
        DispatchQueue.main.async {
            self.showLoader = true
        }
    }
    func hideProgressLoader(){
        DispatchQueue.main.async {
            self.showLoader = false
        }
    }
}
