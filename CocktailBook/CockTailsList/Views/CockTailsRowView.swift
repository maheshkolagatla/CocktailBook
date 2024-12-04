//
//  CockTailsRowView.swift
//  CocktailBook
//
//  Created by mahesh kolagatla on 26/11/24.
//

import SwiftUI
struct CocktailRowView: View {
    let cocktail: CocktailModel
    let isFavourite:Bool
    var body: some View {
        VStack{
            HStack {
                Text(cocktail.name)
                    .font(.headline)
                    .foregroundColor(isFavourite ? .blue : .primary)
                Spacer()
            }
            HStack {
                Text(cocktail.shortDescription)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Spacer()
                if isFavourite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.blue)
                }
            }
        }
        
    }
}
