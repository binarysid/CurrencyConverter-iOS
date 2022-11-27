//
//  Router.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 14/10/22.
//

import Foundation

protocol RoutingLogic {
  func routeToPageX()
}
//There are two protocols should be declared in Router:
//Routing Logic Protocol - all the methods used for routing are kept under this protocol.
//Data Passing Protocol - a protocol that contains the data that needs to be passed to the destination controller.
final class Router{
    var view: ConverterView?
}

extension Router:RoutingLogic{
    func routeToPageX(){
        
    }
}
