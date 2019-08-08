//
//  CardCollectionViewCell.swift
//  Math App
//
//  Created by Soulthidapo on 2019/07/15.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    
    var card:Card?
    
    func setCard(_ card:Card) {
        
        //Keep track of the card that get passed in
        self.card = card
        
        if card.isMatched == true {  //L09
            
            //if the card has been matched, then make the image views invisible
            backImageView.alpha = 0
            frontImageView.alpha = 0
            
            return
        }
        else{
            //if the card has been matched, then make the image views visible
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        frontImageView.image = UIImage(named: card.imageNmae)
        
        //Determain the card is a flip up state or flip down state
        if card.isFlipped == true{
            //Make sure front Imageview is on top
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options:[.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
        else{
            //Make sure back Imageview is on top
              UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
       
    }
    
    func flip() {
        
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        
    }
    
    func flipBack() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            
           UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            
        }
        
    }
    
    func remove() {
        
        //Removes both imageview fro being visible
         backImageView.alpha = 0 //invisible
        
        //Animate it
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            
             self.frontImageView.alpha = 0
            
        }, completion: nil)
        
       
        
    }
    
}
