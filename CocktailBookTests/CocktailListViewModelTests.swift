//
//  CocktailListViewModelTests.swift
//  CocktailBookTests
//
//  Created by mahesh kolagatla on 01/12/24.
//

import XCTest
import Combine
@testable import CocktailBook

final class CocktailListViewModelTests: XCTestCase {
    
    var viewModel: CocktailListViewModel?
    var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        // Set up mock service or real service if needed
        let mockService = CocktailService()
        viewModel = CocktailListViewModel(cockTailServices: mockService)
    }

    override func tearDownWithError() throws {
        // Clean up
        viewModel = nil
        cancellables.removeAll()
    }

   

    func testInitialCocktailLoad() {
        let expectation = self.expectation(description: "Cocktails are loaded")
        viewModel?.$cocktailsList
               .sink { cocktails in
                   if cocktails.count > 0 {
                       expectation.fulfill()  // Fulfill the expectation once data is loaded
                   }
               }
               .store(in: &cancellables)
        viewModel?.fetchCocktails()
        // Wait for the expectation to be fulfilled (timeout after 5 seconds)
         wait(for: [expectation], timeout: 5)
        // Assertions after the data is loaded
        XCTAssertTrue(viewModel!.cocktailsList.count > 0, "cocktails should not have items")
        XCTAssertEqual(viewModel!.filterType, .all, "default filter type is not as expected")
        XCTAssertTrue(viewModel!.filteredCocktailsList.count > 0, "filteredCocktailsList should  not have items")
        XCTAssertTrue(viewModel!.favouriteCocktails.count == 0, "by default there are  favourite items so some thing went wrong")
    }
    func testToggleFavourite() {
        let cocktail =    CocktailModel(id: "1", name: "Mojito", type: "alcoholic", shortDescription: "", longDescription: "A refreshing minty drink", preparationMinutes: 5, imageName: "mojito", ingredients: ["Rum", "Mint", "Sugar", "Lime"])
        
           // Initially, the cocktail should not be in the favorites list
           XCTAssertFalse(viewModel!.isFavourite(cocktail), "Cocktail should not be a favourite initially.")
           // Toggle the favorite status (first time)
           viewModel?.toggleFavourite(for: cocktail)
           
           // Now, it should be marked as a favourite
           XCTAssertTrue(viewModel!.isFavourite(cocktail), "Cocktail should be a favourite after toggling.")
           
           // Toggle the favorite status (second time)
           viewModel?.toggleFavourite(for: cocktail)
           
           // It should be removed from the favorites list
           XCTAssertFalse(viewModel!.isFavourite(cocktail), "Cocktail should not be a favourite after second toggle.")
       }

       
}
