//
//  AllPokemonsResponse.swift
//  pokemondongo
//
//  Created by Betanyeli Bravo on 27-01-23.
//

import Foundation

final class AllPokemonsResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonResult]
}
