//
//  Hand.swift
//  PokerTouch
//
//  Created by Subhi Sbahi on 5/21/17.
//  Copyright © 2017 Rami Sbahi. All rights reserved.
//

import Foundation


class Hand {
    
    var valuesInvolved: [Int] = [] // used to determine ties
    /* royal flush
     * 	just put in a zero
     * straight flush / straight
     * 		returns highest value in the straight - not other cards
     * four/three of kind / one pair
     * 		returns value involved in pair, then high --> low
     * flush
     * 		returns the five cards in flush from high --> low, then the last two values high --> low
     * two pair
     * 		higher pair, lower pair, remaining cards
     * full house
     * 		3 of a kind, pair, remaining
     * none (high card)
     * 	organize high --> low
     */
    
    var outOfIt: [Int] = []
    var cardList: [Card] = []
    var score: Int = 0
    
    init(eCardList: [Card])
    {
        cardList = eCardList
        
        self.sortCards()
        
        let oldScore: Int = self.setScore()
        var oldValues: [Int] = []
        for current in valuesInvolved
        {
            oldValues.append(current)
        }
        
        for currentCard in cardList
        {
            currentCard.makeAceLow()
        }
        
        self.sortCards()
        
        if(self.setScore() <= oldScore) // not any better
        {
            for currentCard in cardList
            {
                currentCard.makeAceHigh()
            }
            score = oldScore
            valuesInvolved = oldValues
        }
        // if it was improved, it will stay that way
        
        self.sortCards()
    }
    
    /**
     * Insertion sort
     */
    func sortCards()
    {
        var key: Int = 0
        for index in 1..<cardList.count
        {
            let currentCard: Card = cardList[index]
            key = index
            
            while(key > 0 && cardList[key - 1].compareTo(otherCard: cardList[index]) < 0)
            {
                key -= 1
            }
            cardList.insert(currentCard, at: key)
            cardList.remove(at: index + 1)
        }
    }
    
    
    
    func setScore() -> Int
    {
        if(self.isRoyalFlush())
        {
            score = 9
        }
        else if(self.isStraightFlush())
        {
            score = 8
        }
        else if(self.isFourOfKind())
        {
            score = 7
        }
        else if(self.isFullHouse())
        {
            score = 6
        }
        else if(self.isFlush())
        {
            score = 5
        }
        else if(self.isStraight())
        {
            score = 4
        }
        else if(self.isThreeOfKind())
        {
            score = 3
        }
        else if(self.isTwoPair())
        {
            score = 2
        }
        else if(self.isPair())
        {
            score = 1
        }
        else
        {
            score = 0
            valuesInvolved.removeAll() // should already be clear, but just double-checking
            for current in cardList
            {
                valuesInvolved.append(current.myValue)
            }
        }
        return score
    }
    
    func isPair() -> Bool
    {
        var cards = [Int](repeating: 0, count: 15)
        for currentCard in cardList
        {
            cards[currentCard.myValue] += 1
        }
        
        for index in 1..<cards.count
        {
            if(cards[index] >= 2)
            {
                valuesInvolved.removeAll()
                valuesInvolved.append(index) // add that value
                for current in cardList
                {
                    let currentValue: Int = current.myValue
                    if(currentValue != index)
                    {
                        valuesInvolved.append(currentValue)
                    }
                }
                return true
            }
        }
        return false
    }
    
    func isFullHouse() -> Bool
    {
        if(isThreeOfKind() && isTwoPair()) // all full houses are a two pair and a three of kind
        {
            return true
        }
        return false
    }
    
    func isTwoPair() -> Bool
    {
        var cards = [Int](repeating: 0, count: 15)
        for currentCard in cardList
        {
            cards[currentCard.myValue] += 1
        }
        
        var count: Int = 0
        var values: [Int] = []
        for index in (1...14).reversed()
        {
            if(cards[index] >= 2)
            {
                count += 1
                if(cards[index] >= 3) // makes full house, needs priority
                {
                     values.insert(index, at: 0)
                }
                else
                {
                    values.append(index)
                }
            }
        }
        var numAdded: Int = 0
        if(count >= 2) // at least 2 pairs
        {
            valuesInvolved.removeAll()
            for value in values
            {
                if(numAdded <= 1) // 2 pairs have not been accounted for yet
                {
                    valuesInvolved.append(value)
                    numAdded += 1
                }
            }
            for current in cardList
            {
                let currentValue: Int = current.myValue;
                if(!valuesInvolved.contains(currentValue))
                {
                    valuesInvolved.append(currentValue)
                }
            }
            return true
        }
        return false
    }
    
    func isThreeOfKind() -> Bool
    {
        var cards = [Int](repeating: 0, count: 15)
        for currentCard in cardList
        {
            cards[currentCard.myValue] += 1
        }
        
        for index in 1..<cards.count
        {
            if(cards[index] >= 3)
            {
                valuesInvolved.removeAll()
                valuesInvolved.append(index) // add that value
                for current in cardList
                {
                    let currentValue: Int = current.myValue
                    if(currentValue != index)
                    {
                        valuesInvolved.append(currentValue)
                    }
                }
                return true
            }
        }
        return false
    }
    
    func isFourOfKind() -> Bool
    {
        var cards = [Int](repeating: 0, count: 15)
        for currentCard in cardList
        {
            cards[currentCard.myValue] += 1
        }
        
        for index in 1..<cards.count
        {
            if(cards[index] == 4)
            {
                valuesInvolved.removeAll()
                valuesInvolved.append(index) // add that value
                for current in cardList
                {
                    let currentValue: Int = current.myValue
                    if(currentValue != index)
                    {
                        valuesInvolved.append(currentValue)
                    }
                }
                return true
            }
        }
        return false
    }
    
    func containsValue(_ val: Int) -> Bool
    {
        for current in cardList
        {
            if(current.myValue == val)
            {
                return true
            }
        }
        return false
    }
    
    func containsCard(c: Card) -> Bool
    {
        for current in cardList
        {
            if(current.equals(otherCard: c))
            {
                return true
            }
        }
        return false
    }
    
    func isStraightFlush() -> Bool
    {
        return  self.isFlush() && self.isStraight() // will clear and put only highest value involved after flush
    }
    
    func isStraight() -> Bool
    {
        for start in (1...10).reversed()
        {
            if(self.containsValue(start) && self.containsValue(start+1) && self.containsValue(start+2) && self.containsValue(start+3) && self.containsValue(start+4))
            {
                valuesInvolved.removeAll()
                valuesInvolved.append(start+4) // value of highest card in straight
                return true
            }
        }
        return false
    }
    
    func isFlush() -> Bool
    {
        var suits = [Int](repeating: 0, count: 5); // 1 = clubs, 2 = hearts, 3 = spades, 4 = diamonds
        for i in 0..<cardList.count
        {
            suits[cardList[i].getSuitValue()] += 1
        }
        
        for j in 1...4
        {
            if(suits[j] >= 5) // this suit makes a flush
            {
                valuesInvolved.removeAll()
                outOfIt.removeAll()
                for index in 0..<cardList.count
                {
                    if(cardList[index].getSuitValue() == j)
                    {
                        valuesInvolved.append(cardList[index].myValue) // will add high --> low of flush
                    }
                    else
                    {
                        outOfIt.append(cardList[index].myValue)
                    }
                }
                for out in outOfIt
                {
                    valuesInvolved.append(out)
                }
                return true
            }
        }
        return false
    }
    
    func isRoyalFlush() -> Bool
    {
        if(self.containsValue(10) && self.containsValue(11) && self.containsValue(12)
            && self.containsValue(13) && self.containsValue(14) && self.isFlush())
        {
            valuesInvolved.removeAll()
            valuesInvolved.append(0)
            return true
        }
        else
        {
            return false
        }
    }
    
    func getImages() -> [String]
    {
        var images: [String] = []
        for current in cardList
        {
            images.append(current.getImage())
        }
        return images
    }
}


