//
//  Configurator.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 8/10/22.

import SwiftUI

//This holds the responsibility of configuring the relationship cycle between view, viewModel, interactor, worker, and presenter.
extension ViewModel {
    func configure(){
        let view = self
        let interactor = Interactor()
        let presenter = Presenter()
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
    }
}

extension ConverterView{
    @discardableResult
    func configure()->some View{
        var view = self
        let router = Router()
        view.router = router
        return view
    }
}
