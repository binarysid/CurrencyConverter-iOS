//
//  ViewModel.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 14/10/22.
//

import Foundation
import Combine
import Swinject

protocol LoaderProtocol{
    func showProgressLoader()
    func hideProgressLoader()
}

final class ViewModel:ObservableObject{

    @Inject
    private var apiWorker: NetWorkerProtocol
    @Inject
    private var persistenceWorker: PersistenceWorkerProtocol
    @Inject
    private var conversionWorker: ConversionWorker
    @Published var viewObject:[DomainRate] = []
    @Published var currencyRate:String = "1.00"{
        didSet{ // once the selected currency rate changes this will trigger the new calculation for currency rate
            self.fetchConvertedCurrency()
        }
    }
    @Published var selectedCurrency:String = "USD"{
        didSet{ // once the selected currency changes this will trigger the new calculation for currency rate
            self.fetchConvertedCurrency()
        }
    }
    @Published var showLoader = false
    var subscriptions = Set<AnyCancellable>()
    init(){
        self.subscribeToCurrencyConversion()
    }
    func currencyList(){
        self.showProgressLoader()
        persistenceWorker.publisher
            .sink(
                receiveCompletion: {[weak self] completion in
                    if case .failure(_) = completion{
                        self?.getDataFromAPI()
                    }
                }, receiveValue: {[weak self] domainObject in
                    self?.hideProgressLoader()
                    self?.setViewObject(domainObject)
                })
            .store(in: &subscriptions)
        persistenceWorker.getDomainData()
    }
    private func getDataFromAPI(){
        let _ = apiWorker.publisher
            .sink(receiveCompletion: {[weak self] completion in
                self?.hideProgressLoader()
                if case .failure(_) = completion{
                    print("failed")
                }
        }, receiveValue: {[weak self] domainObject in
            self?.setViewObject(domainObject)
            self?.hideProgressLoader()
            self?.persistenceWorker.saveCurrencyInBackground(domainObject)
        })
            .store(in: &subscriptions)
        apiWorker.requestForDomainData()
    }
}
extension ViewModel{
    private func fetchConvertedCurrency(){
        guard let amount = Double(currencyRate) else{return}
        self.conversionWorker.getConvertedCurrency(from: selectedCurrency, amount: amount, data: self.viewObject)
    }
    private func subscribeToCurrencyConversion(){
        let _ = self.conversionWorker.subscriber
            .sink(receiveCompletion: {completion in
                if case .failure(_) = completion{
                    print("failed")
                }
            }, receiveValue: {[weak self] domainObject in
                self?.setViewObject(domainObject)
            })
            .store(in: &subscriptions)
    }
}
extension ViewModel{
    private func setViewObject(_ data:[DomainRate]) {
        DispatchQueue.main.async { [weak self] in
            self?.viewObject = self?.sortAlphabetically(data: data) ?? data
        }
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
    private func sortAlphabetically(data:[DomainRate])->[DomainRate]{
        return data.sorted { $0.currency < $1.currency }
    }
}
