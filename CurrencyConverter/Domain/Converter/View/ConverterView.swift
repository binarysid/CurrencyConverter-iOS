//
//  ContentView.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 8/10/22.
//

import SwiftUI

// Our View only knows the ViewModel and Router for data and navigation respectively.
struct ConverterView: View {
    @StateObject var viewModel = ViewModel()
    var router: RoutingLogic?
    var color: Color{
        let colors:[Color] = [.blue,.cyan,.red]
        return colors.randomElement()!
    }
    private let grid = [
        GridItem(.adaptive(minimum: 70,maximum: 80))
    ]
    var body: some View {
        NavigationView{
            VStack {
                currencyInput()
                Spacer(minLength: 8)
                if viewModel.showLoader{
                    loader()
                }
                currencyPicker()
                Spacer(minLength: 8)
                currencyCards()
            }
            .padding()
        }.viewDidLoad {
            viewModel.currencyList()
        }
    }
}
extension ConverterView{
    func currencyPicker()-> some View{
        Picker("currecy", selection: $viewModel.selectedCurrency) {
            ForEach(viewModel.viewObject, id: \.currency) {
                Text($0.currency)
            }
        }
        .pickerStyle(.menu)
        .foregroundColor(.red)
    }
    func loader()-> some View{
        ProgressView().progressViewStyle(CircularProgressViewStyle())
    }
    func currencyInput()-> some View{
        TextField("Enter rate",
                  text: $viewModel.currencyRate)
            .keyboardType(.numberPad)
            .textFieldStyle(.roundedBorder)
    }
    func currencyCards()-> some View{
        ScrollView{
            LazyVGrid(columns: grid,
                      alignment: .center,
                      spacing: 10){
                ForEach(viewModel.viewObject,id:\.currency){data in
                    ZStack{
                        Rectangle()
                            .frame(width: 80, height: 70)
                            .cornerRadius(10)
                            .foregroundColor(color)
                        VStack{
                            Text("\(data.currency)")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                            Text("\(data.rate)")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                        }
                        .padding()
                        .multilineTextAlignment(.center)
                    }
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView()
    }
}
