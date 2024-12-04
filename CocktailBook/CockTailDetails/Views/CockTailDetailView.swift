//
//  CockTailDetailView.swift
//  CocktailBook
//
//  Created by mahesh kolagatla on 28/11/24.
//

import SwiftUI

struct CockTailDetailView: View {
    var cocktailModel: CocktailModel
    @ObservedObject var viewModel: CocktailListViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 10) {
                HStack {
                    Image(systemName: "clock")
                    Text("Preparation Time: \(cocktailModel.preparationMinutes) mins")
                        .font(.headline)
                    Spacer()
                }
                .padding(.horizontal)
                
                Image(cocktailModel.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()
                
                Text(cocktailModel.longDescription)
                    .padding(.horizontal)
                
                Text("Ingredients")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                ForEach(cocktailModel.ingredients, id: \.self) { ingredient in
                    HStack {
                        Image(systemName: "leaf")
                        Text(ingredient)
                        Spacer()
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarItems(trailing: Button(action: {
            viewModel.toggleFavourite(for: cocktailModel)
        }) {
            Image(systemName: viewModel.isFavourite(cocktailModel) ? "heart.fill" : "heart")
        })
        .navigationBarTitle(cocktailModel.name)
    }
}

//#Preview {
//   // CockTailDetailView(cocktail: $cocktail)
//}
