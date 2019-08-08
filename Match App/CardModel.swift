//
//  CardModel.swift
//  Match App
//
//  Created by Soulthidapo on 2019/07/16.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation

class CardMode{
    
    func getCards() -> [Card]{
        
        // Declere an array to store number we've already generated
        
        var generatedNumbersArray = [Int]()
        
        //Declare an array to store the generated cards
        var generatedCardsArray = [Card]()
        //Randomly generate pairs of cards
        
        //for _ in 1...8{
        while generatedNumbersArray.count < 8 {   //change L11
            
            //Get a random number
            let randomNumber = arc4random_uniform(13) + 1 //0 to 12 +1  ---1 to 13
            
            //L11
            //Ensure that the random number isn't one we already have
            if generatedNumbersArray.contains(Int(randomNumber)) == false{
                
                //Log the Random Number
                print(randomNumber)
                
                // Store the number into the generateNumbersArray L11
                generatedNumbersArray.append(Int(randomNumber))
                
                //Create the first card object
                let cardOne = Card()
                cardOne.imageNmae = "card\(randomNumber)"
                
                generatedCardsArray.append(cardOne)
                
                //Create the second card object
                let cardTwo = Card()
                cardTwo.imageNmae = "card\(randomNumber)"
                
                generatedCardsArray.append(cardTwo)
            }
            
            // Make is So we only have unique pair of cards
        }
        
        //Randomize the array   L11
        
        
        for i in 0...generatedCardsArray.count-1{ //if count index out of range error
            
            //Find a random index to swap with
            let randomNumber = Int(arc4random_uniform(UInt32(generatedCardsArray.count)))
            
            //Swap the two cards ------ Swapping the card spot at 0
            let temporaryStorage = generatedCardsArray[i]
            generatedCardsArray[i] = generatedCardsArray[randomNumber]
            generatedCardsArray[randomNumber] = temporaryStorage
        }
        
        //Return the array
        return generatedCardsArray
    }
}
