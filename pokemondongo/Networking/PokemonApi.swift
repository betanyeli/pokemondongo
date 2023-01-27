//
//  PokemonApi.swift
//  pokemondongo
//
//  Created by Betanyeli Bravo on 27-01-23. Buscar q rayos es un singleton :c
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

enum Path: String {
    case allPokemons = "/api/v2/pokemon"
}

protocol PokemonAPIProtocol {
    func getAllPokemons(query: String, completionHandler: @escaping (AllPokemonsResponse) -> Void)
}

struct PokemonAPI: PokemonAPIProtocol  {
    
    static let baseURL = "pokeapi.co"
    
    func getAllPokemons(query: String, completionHandler: @escaping (AllPokemonsResponse) -> Void) {
        guard let url = buildUrl(path: .allPokemons) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  error == nil
            else {                                                               // check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            do {
                let pokemonResponse = try JSONDecoder().decode(AllPokemonsResponse.self, from: data)
                completionHandler(pokemonResponse)
            } catch {
                print(error) // parsing error
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                } else {
                    print("unable to parse response as string")
                }
            }
        }
        
        task.resume()
    }
    
    private func buildUrl(path: Path) -> URL? {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = PokemonAPI.baseURL
        components.path = path.rawValue
        //        components.queryItems = queryItems
        
        return components.url
    }
    
}
