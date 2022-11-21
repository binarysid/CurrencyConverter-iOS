//
//  Configurator.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 8/10/22.

import SwiftUI


extension ConverterView{
    @discardableResult
    func configure()->some View{
        var view = self
        DIManager.shared.registerAPIWorker()
        DIManager.shared.registerPersistenceWorker()
        DIManager.shared.registerConversionWorker()
        let router = Router()
        view.router = router
        return view
    }
}
