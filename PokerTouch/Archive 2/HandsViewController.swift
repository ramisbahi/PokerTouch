//
//  HandsViewController.swift
//  PokerTouch
//
//  Created by Subhi Sbahi on 6/1/17.
//  Copyright © 2017 Rami Sbahi. All rights reserved.
//

import UIKit

class HandsViewController: UIViewController {
    
    @IBOutlet weak var Card1: UIImageView!
    @IBOutlet weak var Card2: UIImageView!
    @IBOutlet weak var Card3: UIImageView!
    @IBOutlet weak var Card4: UIImageView!
    @IBOutlet weak var Card5: UIImageView!
    
    @IBOutlet weak var Player1: UILabel!
    @IBOutlet weak var Label1: UILabel!
    @IBOutlet weak var Player2: UILabel!
    @IBOutlet weak var Label2: UILabel!
    @IBOutlet weak var Player3: UILabel!
    @IBOutlet weak var Label3: UILabel!
    @IBOutlet weak var Player4: UILabel!
    @IBOutlet weak var Label4: UILabel!
    @IBOutlet weak var Player5: UILabel!
    @IBOutlet weak var Label5: UILabel!
    @IBOutlet weak var Player6: UILabel!
    @IBOutlet weak var Label6: UILabel!
    
    @IBOutlet weak var P1C1: UIImageView!
    @IBOutlet weak var P1C2: UIImageView!
    @IBOutlet weak var P2C1: UIImageView!
    @IBOutlet weak var P2C2: UIImageView!
    @IBOutlet weak var P3C1: UIImageView!
    @IBOutlet weak var P3C2: UIImageView!
    @IBOutlet weak var P4C1: UIImageView!
    @IBOutlet weak var P4C2: UIImageView!
    @IBOutlet weak var P5C1: UIImageView!
    @IBOutlet weak var P5C2: UIImageView!
    @IBOutlet weak var P6C1: UIImageView!
    @IBOutlet weak var P6C2: UIImageView!
    
    static let handNames = ["None", "One Pair", "Two Pair", "Three of a Kind", "Straight", "Flush", "Full House", "Four of a Kind", "Straight Flush", "Royal Flush"]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        let communityLabels = [Card1, Card2, Card3, Card4, Card5]
        let playerLabels = [Player1, Player2, Player3, Player4, Player5, Player6]
        let handLabels = [Label1, Label2, Label3, Label4, Label5, Label6]
        let firstCards = [P1C1, P2C1, P3C1, P4C1, P5C1, P6C1]
        let secondCards = [P1C2, P2C2, P3C2, P4C2, P5C2, P6C2]
        
        for i in 0..<5
        {
            communityLabels[i]?.image = UIImage(named: GameViewController.myRunner.myDeck.communityCards[i].getImage())
        }
        
        for j in 0..<6
        {
            if(j < GameViewController.myRunner.myPlayers.count)
            {
                firstCards[j]?.isHidden = false
                secondCards[j]?.isHidden = false
                if(GameViewController.myRunner.myPlayers[j].isBetting)
                {
                    var myLabelText = ""
                    if((!GameViewController.myRunner.wasTie && j == GameViewController.myRunner.recentWinner) || (GameViewController.myRunner.wasTie && GameViewController.myRunner.recentWinners.contains(j)))
                    {
                        myLabelText = GameViewController.myRunner.myPlayers[j].myName + " - Winner!"
                    }
                    else
                    {
                        myLabelText = GameViewController.myRunner.myPlayers[j].myName
                    }
                    playerLabels[j]?.text = myLabelText
                    handLabels[j]?.text = HandsViewController.handNames[GameViewController.myRunner.getHand(index: j).score]
                    firstCards[j]?.image = UIImage(named: GameViewController.myRunner.myPlayers[j].card1.getImage())
                    secondCards[j]?.image = UIImage(named: GameViewController.myRunner.myPlayers[j].card2.getImage())
                }
                else
                {
                    playerLabels[j]?.text = GameViewController.myRunner.myPlayers[j].myName
                    handLabels[j]?.text = "Folded"
                }
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
