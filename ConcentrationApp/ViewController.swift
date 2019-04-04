//
//  ViewController.swift
//  ConcentrationApp
//
//  Created by Crafter on 3/28/19.
//  Copyright © 2019 Crafter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let emojiSets = [0 : ["🦇", "😱", "🙀", "😈", "🎃", "👻", "🍭", "🍬", "🍎"],
                     1 : ["🐏", "🐖", "🐈", "🐇", "🦝", "🦏", "🦔", "🐎", "🐓"],
                     2 : ["🍏", "🍋", "🍅", "🥭", "🥑", "🍆", "🥔", "🥥", "🍌"],
                     3 : ["💻", "📱", "🖨", "💿", "☎️", "📺", "🎥", "⌚️", "⏰"],
                     4 : ["♋️", "♒️", "♍️", "♓️", "♐️", "♏️", "♎️", "♈️", "♌️"],
                     5 : ["A", "B", "C", "D", "E", "F", "G", "H", "I"]]
    
    //    ["", "", "", "", "", "", "", "", ""]
    
    lazy var emojiChoices = randomEmojiTheme(for: Int(arc4random_uniform(UInt32(emojiSets.count))))
    
    
    func randomEmojiTheme(for index: Int) -> [String] {
        return emojiSets[index] ?? ["🦇", "😱", "🙀", "😈", "🎃", "👻", "🍭", "🍬", "🍎"]
    }
    
    
    
    
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
  
    @IBOutlet weak var flipsScoreStack: UIStackView!
    
    @IBOutlet weak var gameOverLabel: UILabel!
    
    @IBOutlet weak var flipCountLabel: UILabel!
 
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var startGameButton: UIButton!
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
              //print("Landscape")
            
            flipsScoreStack.axis = NSLayoutConstraint.Axis.horizontal
            
            gameOverLabel.font = gameOverLabel.font.withSize(25)
            
            startGameButton.titleLabel?.font = startGameButton.titleLabel?.font.withSize(15)
            
            flipCountLabel.font = flipCountLabel.font.withSize(35)                                        
        } else {
            //print("Portrait")
            
             gameOverLabel.font = gameOverLabel.font.withSize(42)
            
            flipsScoreStack.axis = NSLayoutConstraint.Axis.vertical
            
             startGameButton.titleLabel?.font = startGameButton.titleLabel?.font.withSize(37)
            
            flipCountLabel.font = flipCountLabel.font.withSize(40)
        }
    }
    
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            
            var temp: (flips: Int, scores: Int, isGameOver: Bool) = game.chooseCard(at: cardNumber)
            
            flipCountLabel.text = "Flips: \(temp.flips)  "
            scoreLabel.text = "Score: \(temp.scores)  "
            updateViewFromModel()
            
            if temp.isGameOver {
                winFunc()
            }
            
        } else {
            print("choosen card was not in cardButtons")
        }
    }
    
    
    @IBAction func startNewGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        updateViewFromModel()
        emojiChoices = randomEmojiTheme(for: Int(arc4random_uniform(UInt32(emojiSets.count))))
        flipCountLabel.text = "Flips: 0"
        scoreLabel.text = "Score: 0"
        gameOverLabel.textColor = UIColor.black
    }
    
    func winFunc() {
       gameOverLabel.textColor = UIColor.red
    }
    
    
    func updateViewFromModel() {
        for index in cardButtons.indices{
            let button = cardButtons[index]
            let card = game.cards[index]		
            if card.isFaceUp{
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
            else{
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    

    
    var emoji =  [Int:String]()
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
}
