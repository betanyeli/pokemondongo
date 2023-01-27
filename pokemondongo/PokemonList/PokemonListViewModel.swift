//
//  PokemonListViewModel.swift
//  pokemondongo
//
//  Created by Betanyeli Bravo on 27-01-23. //published observable
//

import Foundation

class PokemonListViewModel {
    private let pokemonAPI = PokemonAPI()
    @Published var pokemonResult: [PokemonResult]?
    
    init() {
        pokemonAPI.getAllPokemons(query: "") { [weak self] response in
            print(response)
            guard let self = self else { return }
                    self.pokemonResult = response.results
        }
    }
}
