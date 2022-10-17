//
//  ViewLoadModifier.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 14/10/22.
//

import SwiftUI

struct ViewLoadModifier: ViewModifier {
    
    @State private var hasLoaded = false
    private let action: (() -> Void)?
    
    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            if hasLoaded == false {
                hasLoaded = true
                action?()
            }
        }
    }
    
}

extension View {
    
    func viewDidLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewLoadModifier(perform: action))
    }
    
}
