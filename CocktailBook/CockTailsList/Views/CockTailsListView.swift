//
//  CockTailsListView.swift
//  CocktailBook
//
//  Created by mahesh kolagatla on 25/11/24.
//

import SwiftUI
import Combine
struct CockTailsListView: View {
    @ObservedObject private var viewModel = CocktailListViewModel(
        cockTailServices:CocktailService()
    )
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.filteredCocktailsList.isEmpty && viewModel.errorMessage == nil {
                    Text("Loading...")
                        .foregroundColor(.gray)
                        .padding()
                } else if viewModel.errorMessage != nil {
                    VStack {
                        Text(viewModel.errorMessage ?? "")
                            .foregroundColor(.red)
                        Button(action: {
                            viewModel.retryFetching()
                        }) {
                            Text("Retry")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
                else{
                    Picker("CockTail", selection: $viewModel.filterType) {
                        Text("All").tag(CocktailType?.some(.all))
                        Text("Alcoholic").tag(CocktailType?.some(.alcoholic))
                        Text("Non-Alcoholic").tag(CocktailType?.some(.nonAlcoholic))
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    if viewModel.filteredCocktailsList.isEmpty {
                        Text("Loading...")
                            .foregroundColor(.gray)
                            .padding()
                    }
                    
                    List(viewModel.filteredCocktailsList) { cocktail in
                        NavigationLink(destination: CockTailDetailView(cocktailModel: cocktail, viewModel: viewModel) ) {
                            CocktailRowView(cocktail: cocktail,isFavourite: viewModel.isFavourite(cocktail))
                        }
                    }
                    
                    
                }
                
            }
            .navigationBarTitle(viewModel.filterType?.rawValue.capitalized ?? "All Cocktails")
        }
        .onReceive(viewModel.$filterType) { newFilter in
            viewModel.applyFilter(newFilter)
        }
        .onAppear(){
            viewModel.fetchCocktails()
        
        }
        
    }
    
}

#Preview {
    CockTailsListView()
}

