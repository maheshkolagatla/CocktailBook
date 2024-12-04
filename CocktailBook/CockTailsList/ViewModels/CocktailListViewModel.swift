//
//  CocktailListViewModel.swift
//  CocktailBook
//
//  Created by mahesh kolagatla on 25/11/24.
//

import Combine
import SwiftUI
class CocktailListViewModel: ObservableObject {
    @Published var cocktailsList: [CocktailModel] = []
    @Published var filteredCocktailsList: [CocktailModel] = []
    @Published var filterType: CocktailType?  // Default to All
    @Published var errorMessage: String? = nil
    @Published var favouriteCocktails: Set<String> = [] // Store IDs of favourite cocktails
    
    private var cancellables = Set<AnyCancellable>()
    private let cockTailServices: CocktailServiceProtocol
    
    init(cockTailServices: CocktailServiceProtocol) {
        self.cockTailServices = cockTailServices
    }
    
    func applyFilter(_ filterType: CocktailType?) {
        guard let filter = filterType else {
            filteredCocktailsList = cocktailsList
            return
        }
        switch filter {
        case .all:
            filteredCocktailsList = cocktailsList
        case .alcoholic:
            filteredCocktailsList = cocktailsList.filter { $0.type == "alcoholic" }
        case .nonAlcoholic:
            filteredCocktailsList = cocktailsList.filter { $0.type == "non-alcoholic" }
        }
        sortAndFilterFavouriteItems()
    }
    
  
    
    func fetchCocktails() {
            cockTailServices.fetchCocktails()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        // No action needed, data is successfully received
                        break
                    case .failure(let error):
                        // Handle the error (e.g., show an error message)
                        self?.errorMessage = "Failed to load cocktails: \(error.localizedDescription)"
                    }
                }, receiveValue: { [weak self] cocktails in
                    self?.cocktailsList = cocktails.sorted { $0.name < $1.name }
                    if let result =  UserDefaults.standard.value(forKey: "favoriteCocktails") as? [String]{
                        self?.favouriteCocktails = Set(result)
                    }
                    self?.filterType = CocktailType.all
                    self?.applyFilter(self?.filterType)  // Apply filter after data is loaded

                })
                .store(in: &cancellables)
        }

    
    func toggleFavourite(for cocktail: CocktailModel) {
        if favouriteCocktails.contains(cocktail.id) {
            favouriteCocktails.remove(cocktail.id)
        } else {
            favouriteCocktails.insert(cocktail.id)
        }
        self.sortAndFilterFavouriteItems()
        let favoriteIds = Array(favouriteCocktails)  // Convert Set back to an Array
        UserDefaults.standard.set(favoriteIds, forKey: "favoriteCocktails")
        
    }
    func isFavourite(_ cocktail: CocktailModel) -> Bool {
        favouriteCocktails.contains(cocktail.id)
    }
  
    
    func retryFetching() {
           self.errorMessage = nil
           self.fetchCocktails()    
       }
    func sortAndFilterFavouriteItems(){
        let matchingModels = filteredCocktailsList
            .filter { favouriteCocktails.contains($0.id) }
            .sorted { $0.name.localizedCompare($1.name) == .orderedAscending }

        // Step 2: Filter and sort non-matching models
        let nonMatchingModels = filteredCocktailsList
            .filter { !favouriteCocktails.contains($0.id) }
            .sorted { $0.name.localizedCompare($1.name) == .orderedAscending }

        // Step 3: Combine both lists
        let finalList = matchingModels + nonMatchingModels
        filteredCocktailsList = finalList
    }
}
