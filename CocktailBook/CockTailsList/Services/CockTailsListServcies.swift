//
//  CockTailsListServcies.swift
//  CocktailBook
//
//  Created by mahesh kolagatla on 26/11/24.
//
import Foundation
import Combine
protocol CocktailServiceProtocol {
    func fetchCocktails() -> AnyPublisher<[CocktailModel], Error>
}
class CocktailService: CocktailServiceProtocol {
    private let api: CocktailsAPI
    
    
    init(api: CocktailsAPI = FakeCocktailsAPI(withFailure: .count(3))) {  // Fail for the first 3 attempts
            self.api = api
    }
    
    func fetchCocktails() -> AnyPublisher<[CocktailModel], Error> {
        api.cocktailsPublisher
            .retry(3)
            .mapError { error -> Error in
                            // Transform the error into a general Error type
                return error
            }// Retry 3 times before failing
            .decode(type: [CocktailModel].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()

    }
}
