//
//  Interactor.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 8/10/22.
//

import Combine

protocol ConversionWorkerProtocol{
    var subscriber:AnyPublisher<[DomainRate], Never> {get}
    func getConvertedCurrency(from currency:String,amount:Double,data:[DomainRate]?)
}

class ConversionWorker:ConversionWorkerProtocol{
    private var subject = PassthroughSubject<[DomainRate],Never>()
    var subscriber: AnyPublisher<[DomainRate], Never>{
        get {
            subject.eraseToAnyPublisher()
        }
    }
    func getConvertedCurrency(from currency:String,amount:Double,data:[DomainRate]?){
        guard var data = data,let usdRate = data.first(where: { $0.currency == currency })?.rate else{return}
        for (index,item) in data.enumerated(){
            let convertedRate = convert(givenCurrencyRateInUSD: usdRate, expectedCurrencyRateInUSD: item.rate, amount: amount)
            data[index].rate = convertedRate.rounding(to: 3)
        }
        subject.send(data)
//        subject.send(completion: .finished)
        
    }
    // from the API we only get 1 unit USD rate. so for converting from other currencies the formula is:
    // desiredRate = (totalAmount/USDRate)*expectedCurrencyRateInUSD
    func convert( givenCurrencyRateInUSD rate1:Double,expectedCurrencyRateInUSD rate2:Double,amount:Double)->Double{
        let amountInUSD = amount/rate1
        return (rate2*amountInUSD)
    }
}

