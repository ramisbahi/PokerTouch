//
//  GameViewController.swift
//  PokerTouch
//
//  Created by Subhi Sbahi on 5/28/17.
//  Copyright © 2017 Rami Sbahi. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    static var myRunner = PokerRunner(players: [])
    var myCurrentPlayer = Player(name: "")
    static var count = 0
    
    @IBOutlet weak var Card1: UIImageView!
    @IBOutlet weak var Card2: UIImageView!
    @IBOutlet weak var Card3: UIImageView!
    @IBOutlet weak var Card4: UIImageView!
    @IBOutlet weak var Card5: UIImageView!
    
    @IBOutlet weak var PlayerLabel1: UILabel!
    @IBOutlet weak var PlayerLabel2: UILabel!
    @IBOutlet weak var PlayerLabel3: UILabel!
    @IBOutlet weak var PlayerLabel4: UILabel!
    @IBOutlet weak var PlayerLabel5: UILabel!
    @IBOutlet weak var PlayerLabel6: UILabel!
    
    @IBOutlet weak var MoneyLabel1: UILabel!
    @IBOutlet weak var MoneyLabel2: UILabel!
    @IBOutlet weak var MoneyLabel3: UILabel!
    @IBOutlet weak var MoneyLabel4: UILabel!
    @IBOutlet weak var MoneyLabel5: UILabel!
    @IBOutlet weak var MoneyLabel6: UILabel!
    
    @IBOutlet weak var BetLabel1: UILabel!
    @IBOutlet weak var BetLabel2: UILabel!
    @IBOutlet weak var BetLabel3: UILabel!
    @IBOutlet weak var BetLabel4: UILabel!
    @IBOutlet weak var BetLabel5: UILabel!
    @IBOutlet weak var BetLabel6: UILabel!
    
    @IBOutlet weak var TurnLabel: UILabel!
    @IBOutlet weak var PotLabel: UILabel!
    
    @IBOutlet weak var RaiseButton: UIButton!
    @IBOutlet weak var CallButton: UIButton!
    @IBOutlet weak var CheckButton: UIButton!
    @IBOutlet weak var FoldButton: UIButton!
    
    
    var flipped = false
    @IBOutlet weak var Card1Image: UIImageView!
    @IBOutlet weak var Card2Image: UIImageView!
    
    @IBOutlet weak var EndButton: UIButton!
    
    @IBAction func flip(_ sender: Any) {
        
        if(flipped == false)
        {
            Card1Image.image = UIImage(named: myCurrentPlayer.card1.getImage())
            Card2Image.image = UIImage(named: myCurrentPlayer.card2.getImage())
            flipped = true
        }
        else
        {
            Card1Image.image = UIImage(named: "back")
            Card2Image.image = UIImage(named: "back")
            flipped = false
        }
    }
    
    @IBAction func fold(_ sender: Any)
    {
        GameViewController.myRunner.fold()
        if(GameViewController.myRunner.othersFolded())
        {
            GameViewController.myRunner.win(winner: GameViewController.myRunner.currentPlayerIndex)
            self.performSegue(withIdentifier: "foldSegue", sender: nil)
            
        }
        self.postButton()
    }
    
    @IBAction func check(_ sender: Any)
    {
        self.postButton()
    }
    
    @IBAction func call(_ sender: Any) // match bet
    {
        GameViewController.myRunner.call()
        self.postButton()
    }
    
    // Ask how much to add, tell currentNecessary, make raise if valid
    @IBAction func raise(_ sender: Any)
    {
        
        //1. Create the alert controller.
        var myMessage: String = ""
        if(GameViewController.myRunner.currentNecessary > 0)
        {
            myMessage = "Bet at least " + String(GameViewController.myRunner.currentNecessary)
        }
        let alert = UIAlertController(title: "How much would you like to add?", message: myMessage, preferredStyle: .alert)
        
        //2. Add the text field.
        alert.addTextField { (textField) in textField.text = ""
        }
        
        // 3. Grab the value from the text field
        alert.addAction(UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("textField: " + (textField?.text)!)
            let eAmount = Int((textField?.text)!)
            if(eAmount != nil && eAmount! >= GameViewController.myRunner.currentNecessary)
            {
                GameViewController.myRunner.bet(amount: eAmount!)
                print(eAmount) // this means we did the bet method
                self.postButton()
            }
            else
            {
                // ask again - no input
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
     Standard updates after raise/check/call/fold
    */
    func postButton()
    {
        self.updateLabels()
        self.disableButtons()
        GameViewController.myRunner.nextPlayer()
        self.EndButton.isHidden = false
    }
    
    func disableButtons()
    {
        RaiseButton.isEnabled = false
        CallButton.isEnabled = false
        CheckButton.isEnabled = false
        FoldButton.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(false)
        
        if(ViewController.newGame) // make sure only runs when new game
        {
            var myPlayers: [Player] = []
            
            for playerName in ViewController.playerNames
            {
                myPlayers.append(Player(name: playerName))
            }
            
            GameViewController.myRunner = PokerRunner(players: myPlayers)
            
            TurnLabel.text = myPlayers[0].myName + "'s Turn"
            PotLabel.text = "Pot: 0"
            
            EndButton.isHidden = true
            flipped = false
            self.updateLabels()
            
            ViewController.newGame = false
        }
        
        myCurrentPlayer = GameViewController.myRunner.currentPlayer
        
        let currentDeck = GameViewController.myRunner.myDeck
        if(GameViewController.myRunner.stage >= 2)
        {
            Card1.image = UIImage(named:currentDeck.communityCards[0].getImage())
            Card2.image = UIImage(named: currentDeck.communityCards[1].getImage())
            Card3.image = UIImage(named: currentDeck.communityCards[2].getImage())
        }
        if(GameViewController.myRunner.stage >= 3)
        {
            Card4.image = UIImage(named: currentDeck.communityCards[3].getImage())
        }
        if(GameViewController.myRunner.stage >= 4)
        {
            Card5.image = UIImage(named: currentDeck.communityCards[4].getImage())
        }
        EndButton.isHidden = true
        flipped = false
        self.updateLabels()
        self.adaptButtons()
    }
    
    // disables buttons that are not permitted
    func adaptButtons()
    {
        if(!GameViewController.myRunner.canCheck()) // can't check b/c doesn't have max bet (so can call)
        {
            CheckButton.isEnabled = false
        }
        else // can check b/c has max bet (so call doesn't make sense)
        {
            CallButton.isEnabled = false
        }
        if(!GameViewController.myRunner.canRaise())
        {
            RaiseButton.isEnabled = false
        }
    }
    
    func updateLabels()
    {
        let playerLabels = [PlayerLabel1, PlayerLabel2, PlayerLabel3,    PlayerLabel4, PlayerLabel5, PlayerLabel6]
        let moneyLabels = [MoneyLabel1, MoneyLabel2, MoneyLabel3, MoneyLabel4, MoneyLabel5, MoneyLabel6]
        let betLabels = [BetLabel1, BetLabel2, BetLabel3, BetLabel4, BetLabel5, BetLabel6]
        let myPlayers = GameViewController.myRunner.myPlayers
        for i in 0...5
        {
            if(i < myPlayers.count)
            {
                playerLabels[i]?.text = myPlayers[i].myName
                moneyLabels[i]?.text = "Money: " + String(myPlayers[i].money)
                if(myPlayers[i].isBetting)
                {
                    betLabels[i]?.text = "Betting: " + String(myPlayers[i].bet)
                }
                else // folded
                {
                    betLabels[i]?.text = "Bet: " + String(myPlayers[i].bet)
                    betLabels[i]?.textColor = UIColor.lightGray
                    playerLabels[i]?.textColor = UIColor.lightGray
                    moneyLabels[i]?.textColor = UIColor.lightGray
                }
            }
            else
            {
                playerLabels[i]?.text = ""
                moneyLabels[i]?.text = ""
                betLabels[i]?.text = ""
            }
        }
        
        PotLabel.text = "Pot: " + String(GameViewController.myRunner.pot)
        TurnLabel.text = myCurrentPlayer.myName + "'s Turn"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func EndTurn(_ sender: Any) {
        
        if(GameViewController.myRunner.stage == 5)
        {
            GameViewController.myRunner.determineWinner()
            self.performSegue(withIdentifier: "EndToHands", sender: nil)
        }
        else
        {
            self.performSegue(withIdentifier: "EndToHandOff", sender: nil)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
     */
    

}
