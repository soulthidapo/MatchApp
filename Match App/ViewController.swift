//
//  ViewController.swift
//  Math App
//
//  Created by Soulthidapo on 2019/07/15.
//  Copyright © 2019 Soul. All rights reserved.


import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {

    @IBOutlet weak var TimerLabel: UILabel!
    
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    var model = CardMode()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex:IndexPath?
    
    var timer:Timer?   //L10 to create actual timer
    var millseconds:Float = 30 * 1000 //10 seconds old
    
    var soundManager = SoundManager() //Sound instentiation L11
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Call the get card og the card model
        cardArray = model.getCards()
        
        collectionview.delegate = self
        collectionview.dataSource = self
        
        //Create timer L10 3 (1000miliseconds in 1 second)

        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer!, forMode: .commonModes)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        soundManager.playSound(.shuffle)
        SoundManager.playSound(.shuffle)   //Type Method
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: -Timer Methods L10
    
    @objc func timerElapsed(){   //TOCHECK  L10 2
        millseconds -= 1
        
        //Convert to seconds
        let seconds = String(format: "%.2f", millseconds/1000)
        
        //Set Label
        TimerLabel.text = "Time Remaining: \(seconds)"
        
        //When the timer has 0...
        if millseconds <= 0{
            timer?.invalidate()   //stop the timer from it run loop
            TimerLabel.textColor = UIColor.red
            
            //Check if there are any card unmatched
            checkGameEnded()
        }
    }
    
    //MARK: - UICollectionView Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(cardArray.count)
        return cardArray.count    //16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Get an CardCollectionViewCell object
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        
        //Get the card that the collection view is trying to display
        let card = cardArray[indexPath.row]
        
        
        //Set the card for the cell
        cell.setCard(card)
        
        return cell
        
    }
    
    //Selected Item
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Check if there's any time left
        if millseconds <= 0{
            return
        }
        
        //Get the cell that the user selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        //Get the card that the user selected
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false{

            //Flip the card
            cell.flip()

            //Play the flip sound L11
            SoundManager.playSound(.flip)
            
            //Set the status of the card
            card.isFlipped = true
            
            
            //Determine if it's the first card or second card that's flipped over L09
            if firstFlippedCardIndex == nil {
                
                //This is the first card being flipped
                firstFlippedCardIndex = indexPath
                
            }
            else{
                
                //This is the second card being flipped
                
                //Perform tje machine logic
                checkForMatches(indexPath)
            }
        }
        
    } //End the didSelectItemAt
    
    //MARK: - Game Logic Methods
    
    func checkForMatches(_ secondFlippedCardIndex:IndexPath) {
        
        //Get the cell for the two cards that were revealed
        let cardOneCell = collectionview.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionview.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        //Get the cards for the two cards that were revealed
        
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        //Compare the two cards
        if cardOne.imageNmae == cardTwo.imageNmae{
            
            //It's a match
            
            // Play sound
            SoundManager.playSound(.match)
            
            //Set the status of the card
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            //Remove the card from the grid
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            //Check if there are any cards left unmached L10
            checkGameEnded()
            
        }
        else
        {
            //It's not a match
            
            //Play sound
            SoundManager.playSound(.nomatch)
            
            //Set the status of the card
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            //Flip both cards back
            
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            
        }
        
        //Tell the collectionview to reload the cell of the first card if it is nil L09
        if cardOneCell == nil {
            collectionview.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        //Reset the property that tracks the first card flipped
        firstFlippedCardIndex = nil
    }
    
    func checkGameEnded(){
        
        //Determine if there are any cards unmatched
        var isWon = true
        
        for card in cardArray{
            
            if card.isMatched == false{
                isWon = false
                break
            }
        }
        
        //Messaging variable
        var title = ""
        var message = ""
        
        // If not,then user has won, stop the timer
        
        if isWon == true{
            
            if millseconds > 0{
                timer?.invalidate()
            }
            
            title = "Congratulation!"
            message = "You've won"
        }else
        {
            //If there are unmatched cards,check if tere's any time left
            if millseconds > 0{
                return
            }
            
            title = "Game Over"
            message = "You've lost"
        }
        
        //Show won or lost messging
        
        showAlert(title, message)
        
        }
    func showAlert(_ title:String, _ message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
} //End the ViewController Class

