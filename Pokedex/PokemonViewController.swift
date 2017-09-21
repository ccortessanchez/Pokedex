//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Carlos Cortés Sánchez on 19/09/2017.
//  Copyright © 2017 Carlos Cortés Sánchez. All rights reserved.
//

import UIKit
import Siesta
import SwiftyJSON

class PokemonViewController: UIViewController, ResourceObserver {
    
    @IBOutlet weak var imageView: RemoteImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var type1Label: UILabel!
    @IBOutlet weak var type2Label: UILabel!
    @IBOutlet weak var spriteSegmentedControl: UISegmentedControl!
 
    var statusOverlay = ResourceStatusOverlay()
    
    override func viewDidLayoutSubviews() {
        statusOverlay.positionToCoverParent()
    }
    
    //MARK: Resource code
    var pokemonResource: Resource? {
        didSet {
            oldValue?.removeObservers(ownedBy: self)
            pokemonResource?.addObserver(self)
                .addObserver(statusOverlay, owner: self)
                .loadIfNeeded()
        }
    }
    
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        showPokemon()
    }
    
    var pokemon: Pokemon? {
        return pokemonResource?.typedContent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusOverlay.embed(in: self)
        showPokemon()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPokemon() {
        if let _pokemon = pokemon {
            let idPokemon = _pokemon.id
            let namePokemon = _pokemon.name.capitalized
            nameLabel?.text = "\(idPokemon): \(namePokemon)"
            imageView?.imageURL = _pokemon.spriteUrlMale
            type1Label?.text = _pokemon.types?[0]
            type2Label?.text = _pokemon.types?[1]
        }
    }
    
    // MARK: Actions
    
    @IBAction func pokemonSpriteControl(_ sender: UISegmentedControl) {
        switch spriteSegmentedControl.selectedSegmentIndex {
        case 0:
            imageView?.imageURL = pokemon?.spriteUrlMale
        case 1:
            if pokemon?.spriteUrlFemale != nil {
                imageView?.imageURL = pokemon?.spriteUrlFemale
            } else {
                imageView?.imageURL = pokemon?.spriteUrlMale
            }
        case 2:
            imageView?.imageURL = pokemon?.spriteUrlShinny
        default:
            break
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
