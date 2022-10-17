//
//  Extensions.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 13/10/22.
//

import Foundation

extension Double{
    func rounding(to decimal: Int) -> Double {
        let div = pow(10.0, Double(decimal))
        return (self * div).rounded()/div
    }
    func checkEqual(to val : Double, decimalPoint : Int) -> Bool{
        let denom:Double = pow(10.0, Double(decimalPoint))
        let maxDiff:Double = 1.0 / denom
        let actualDiff:Double = fabs(self - val)
        if actualDiff >= maxDiff {
            return false
        } else {
            return true
        }
    }
}
