//
//  Deck.swift
//  PokerTouch
//
//  Created by Subhi Sbahi on 5/28/17.
//  Copyright © 2017 Rami Sbahi. All rights reserved.
//

import Foundation

class Deck
{
    var cards: [Card] = []
    var communityCards: [Card] = []
    
    init()
    {
        let suits = ["clubs", "hearts", "spades", "diamonds"]
        for val in 2...14
        {
            for suit in suits
            {
                cards.append(Card(val, suit))
            }
        }
        self.shuffle()
        for i in 0...4
        {
            communityCards.append(cards[i])
        }
    }
    
    func distributeCards(players: [Player])
    {
        var index = 5
        for player in players
        {
            player.assignCards(cards[index], cards[index + 1])
            index += 2
        }
    }
    
    func shuffle()
    {
        for i in 0...(cards.count-2)
        {
            let j: Int = Int(arc4random_uniform(UInt32(cards.count - i))) + i
            swap(i, j)
        }
    }
    
    func swap(_ index1: Int, _ index2: Int)
    {
        let temp = cards[index1]
        cards[index1] = cards[index2]
        cards[index2] = temp
    }
}
