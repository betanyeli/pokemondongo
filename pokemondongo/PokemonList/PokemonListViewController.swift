//
//  PokemonListViewController.swift
//  pokemondongo
//
//  Created by Betanyeli Bravo on 27-01-23. $ suscribirnos  a un observable..
// todo lo q es ui en sw se ejecuta en el thread principal e.e
//

import Foundation
import UIKit
import Combine

final class PokemonListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    let viewModel = PokemonListViewModel()
    lazy var tableView = UITableView()
    private var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setUpView()
        setUpConstraints()
        bindData()
    }
    
    func setUpView() {view.addSubview(tableView)}
    
    func setUpConstraints() {
        tableView.frame = view.bounds
    }
    
    func bindData() {
        cancellable = viewModel.$pokemonResult.receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] _ in
                self?.tableView.reloadData()
            })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pokemonResult?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
                if let pokemonResult = viewModel.pokemonResult?[indexPath.row] {
                    cell.textLabel?.text = pokemonResult.name
                    if let imageUrl = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(indexPath.row + 1).png") {
                        var imageData: NSData = try! NSData(contentsOf: imageUrl)
                        var pokemonImage = UIImage(data: imageData as Data)
                        cell.imageView?.image = pokemonImage
                    }
                }
                return cell
    }
}
