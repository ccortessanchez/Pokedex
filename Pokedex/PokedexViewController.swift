//
//  ViewController.swift
//  Pokedex
//
//  Created by Carlos Cortés Sánchez on 19/09/2017.
//  Copyright © 2017 Carlos Cortés Sánchez. All rights reserved.
//

import UIKit
import Siesta
import SwiftyJSON

class PokedexViewController: UITableViewController, ResourceObserver {

    @IBOutlet weak var pokemonView: UIImageView!
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var pokemonID: UILabel!
    
    var statusOverlay = ResourceStatusOverlay()
    
    override func viewDidLayoutSubviews() {
        statusOverlay.positionToCoverParent()
    }
    
    
    // MARK: - Resource code
    
    //Pokemon list
    var pokemonList: [JSON] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    var pokedexResource: Resource? {
        didSet {
            oldValue?.removeObservers(ownedBy: self)
            
            pokedexResource?
                .addObserver(self)
                .addObserver(statusOverlay, owner: self)
                .loadIfNeeded()
        }
    }
    
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        pokemonList = pokedexResource?.typedContent() ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusOverlay.embed(in: self)
        pokedexResource = PokeAPI.pokedex
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // We'll replace 'objects' with 'pokemon' in the blog post
        return pokemonList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        let pokemonSummary = pokemonList[indexPath.row]
        cell.textLabel?.text = pokemonSummary["name"].stringValue.capitalized
        cell.detailTextLabel?.text = "id: \(indexPath.row + 1)"
        cell.imageView?.image = UIImage(named: "Pokeball.png")
        return cell
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let pokemonVC = segue.destination as? PokemonViewController,
                let indexPath = self.tableView.indexPathForSelectedRow {
                pokemonVC.pokemonResource = PokeAPI.pokemon(id: "\(indexPath.row + 1)")
            }
        }
    }



}

