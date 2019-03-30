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
    var cards = [Card]()
    
    var indexOfOneAndOnlyFaceUp: Int?
    
    func chooseCard(at index: Int) -> (flips: Int, scores: Int, isGameOver: Bool) {
        flipCount += 1
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
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUp = index
            }
        }
        return (flipCount, gameScore, gameOver)
    }
    
    init(numberOfPairsOfCards: Int){
        for _ in 1...numberOfPairsOfCards
        {
            let card = Card()
            cards += [card, card]
        }
        
        cards.shuffle()
        cardInGame = cards.count
    }
    
}
