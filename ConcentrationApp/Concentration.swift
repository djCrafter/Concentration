//
//  Concentration.swift
//  ConcentrationApp
//
//  Created by Crafter on 3/28/19.
//  Copyright © 2019 Crafter. All rights reserved.
//

import Foundation

class Concentration
{
    var gameScore = 0
    var flipCount = 0
    var gameOver = false
    var cardInGame = 0
    private(set) var cards = [Card]()
    
  private var indexOfOneAndOnlyFaceUp: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp{
                    if foundIndex == nil {
                        foundIndex = index
                    }
                    else{
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    
    
    func chooseCard(at index: Int) -> (flips: Int, scores: Int, isGameOver: Bool) {
        
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUp, matchIndex != index {
                var flag = true
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    gameScore += 2
                    cardInGame -= 2
                    
                    if cardInGame < 2 {
                        gameOver = true
                    }
                    
                    flag = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUp = nil
                if flag { gameScore -= 1 }
            }
            else{              
                indexOfOneAndOnlyFaceUp = index
            }
        }
        
        flipCount += 1
        return (flipCount, gameScore, gameOver)
    }
    
    init(numberOfPairsOfCards: Int){
          assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards
        {
            let card = Card()
            cards += [card, card]
        }
        
        cards.shuffle()
        cardInGame = cards.count
    }
    
}
