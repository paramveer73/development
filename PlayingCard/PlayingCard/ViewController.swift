//
//  ViewController.swift
//  PlayingCard
//
//  Created by Paramveer  on 2020-01-14.
//  Copyright © 2020 Paramveer . All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var deck = PlayingCardDeck()
    @IBOutlet weak var playingCardView: PlayingCardView!{
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
            swipe.direction  = [ .left , .right]
            playingCardView.addGestureRecognizer(swipe)
            let pich = UIPinchGestureRecognizer(target: playingCardView, action: #selector(playingCardView.adjustFaceCardScale))
            playingCardView.addGestureRecognizer(pich)
        }
    }
    
    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
        switch  sender.state {
        case .ended:
            playingCardView.isFaceUp = !playingCardView.isFaceUp
        default:
            break
        }
    }
    
    @objc func nextCard(){
        if let card = deck.draw(){
            playingCardView.rank = card.rank.order
            playingCardView.suit = card.suit.rawValue
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additi
        
    }


}

