//
//  Card.swift
//  PokerTouch
//
//  Created by Subhi Sbahi on 5/21/17.
//  Copyright © 2017 Rami Sbahi. All rights reserved.
//

import Foundation

class Card {
    
    static let suits: [String] = ["clubs", "hearts", "spades", "diamonds"]
   	var myValue: Int = 0
    var mySuit: String = ""
    
    init(_ value: Int, _ suit: String)
    {
        myValue = value
        mySuit = suit
    }
    
    
    func makeAceLow()
    {
        if(myValue == 14)
        {
            myValue = 1
        }
    }
    
    func makeAceHigh()
    {
        if(myValue == 1)
        {
            myValue = 14
        }
    }
    
    func getSuitValue() -> Int
    {
        return Card.suits.index(of: mySuit)!
    }
    
    func getValueString() -> String
    {
        if myValue <= 10
        {
            return String(myValue)
        }
        else
        {
            if myValue == 11
            {
                return "jack"
            }
            if myValue == 12
            {
                return "queen"
            }
            if myValue == 13
            {
                return "king"
            }
            if myValue == 14 || myValue == 1
            {
                return "ace"
            }
            else
            {
                return "INVALID"
            }
        }
    }
    
    func getImage() -> String
    {
        return self.getValueString() + mySuit
    }
    
    
    func compareTo(otherCard: Card) -> Int
    {
        if(self.myValue > otherCard.myValue)
        {
            return 1
        }
        else if(self.myValue < otherCard.myValue)
        {
            return -1
        }
        else // equal
        {
            return 0
        }
    }
    
    
    func equals(otherCard: Card) -> Bool
    {
        return self.myValue == otherCard.myValue && self.mySuit == otherCard.mySuit
    }
        
}
