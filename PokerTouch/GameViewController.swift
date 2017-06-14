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
    static var allIn = false
    static var smallBlind = false
    static var bigBlind = false
    
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
    @IBOutlet weak var PlayerLabel7: UILabel!
    @IBOutlet weak var PlayerLabel8: UILabel!
    @IBOutlet weak var PlayerLabel9: UILabel!
    
    
    @IBOutlet weak var MoneyLabel1: UILabel!
    @IBOutlet weak var MoneyLabel2: UILabel!
    @IBOutlet weak var MoneyLabel3: UILabel!
    @IBOutlet weak var MoneyLabel4: UILabel!
    @IBOutlet weak var MoneyLabel5: UILabel!
    @IBOutlet weak var MoneyLabel6: UILabel!
    @IBOutlet weak var MoneyLabel7: UILabel!
    @IBOutlet weak var MoneyLabel8: UILabel!
    @IBOutlet weak var MoneyLabel9: UILabel!
    
    
    @IBOutlet weak var BetLabel1: UILabel!
    @IBOutlet weak var BetLabel2: UILabel!
    @IBOutlet weak var BetLabel3: UILabel!
    @IBOutlet weak var BetLabel4: UILabel!
    @IBOutlet weak var BetLabel5: UILabel!
    @IBOutlet weak var BetLabel6: UILabel!
    @IBOutlet weak var BetLabel7: UILabel!
    @IBOutlet weak var BetLabel8: UILabel!
    @IBOutlet weak var BetLabel9: UILabel!
    
    @IBOutlet weak var TurnLabel: UILabel!
    @IBOutlet weak var PotLabel: UILabel!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
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
            GameViewController.myRunner.win(winner: GameViewController.myRunner.remainingIndex())
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
        if(GameViewController.allIn)
        {
            GameViewController.myRunner.allIn()
            self.postButton()
        }
        else if(GameViewController.smallBlind)
        {
            GameViewController.myRunner.smallBlind()
            self.postButton()
        }
        else if(GameViewController.bigBlind)
        {
            GameViewController.myRunner.bigBlind()
            self.postButton()
        }
    else
    {
        //1. Create the alert controller.
        var myMessage: String = ""
        if(GameViewController.myRunner.currentNecessary > 0)
        {
            myMessage = "Bet at least " + String(GameViewController.myRunner.currentNecessary)
        }
        let alert = UIAlertController(title: "How much would you like to add?", message: myMessage, preferredStyle: .alert)
        
        //2. Add the text field.
        alert.addTextField { (textField) in
            textField.text = ""
            textField.keyboardType = .numberPad
        }
        
        // 3. Grab the value from the text field
        alert.addAction(UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let eAmount: Int? = Int((textField?.text)!)
            if(eAmount != nil && eAmount! >= GameViewController.myRunner.currentNecessary)
            {
                GameViewController.myRunner.bet(amount: eAmount!)
                self.postButton()
            }
            else
            {
                let otherAlert = UIAlertController(title: "Please bet at least \(GameViewController.myRunner.currentNecessary)", message: "", preferredStyle: .alert)
                otherAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(otherAlert, animated: true, completion: nil)
                // ask again - no input
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
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
        
        if(GameViewController.myRunner.currentPlayerIndex > 5)
        {
            var offset = ScrollView.contentOffset
            offset.y = ScrollView.contentSize.height + ScrollView.contentInset.bottom - ScrollView.bounds.size.height
            ScrollView.setContentOffset(offset, animated: true)
        }
        
        EndButton.isHidden = true
        flipped = false
        GameViewController.allIn = false
        GameViewController.smallBlind = false
        GameViewController.bigBlind = false
        
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
        else if(GameViewController.myRunner.mustAllIn())
        {
            RaiseButton.setTitle("All-In", for: .normal)
            GameViewController.allIn = true
            CallButton.isEnabled = false
        }
        else if(GameViewController.myRunner.isSmallBlind())
        {
            RaiseButton.setTitle("Small Blind", for: .normal)
            GameViewController.smallBlind = true
            CheckButton.isEnabled = false
        }
        else if(GameViewController.myRunner.isBigBlind())
        {
            RaiseButton.setTitle("Big Blind", for: .normal)
            GameViewController.bigBlind = true
            CallButton.isEnabled = false
        }
    }
    
    func updateLabels()
    {
        let playerLabels = [PlayerLabel1, PlayerLabel2, PlayerLabel3,    PlayerLabel4, PlayerLabel5, PlayerLabel6, PlayerLabel7, PlayerLabel8, PlayerLabel9]
        let moneyLabels = [MoneyLabel1, MoneyLabel2, MoneyLabel3, MoneyLabel4, MoneyLabel5, MoneyLabel6, MoneyLabel7, MoneyLabel8, MoneyLabel9]
        let betLabels = [BetLabel1, BetLabel2, BetLabel3, BetLabel4, BetLabel5, BetLabel6, BetLabel7, BetLabel8, BetLabel9]
        let myPlayers = GameViewController.myRunner.myPlayers
        for i in 0...8
        {
            if(i < myPlayers.count)
            {
                playerLabels[i]?.text = myPlayers[i].myName
                if(myPlayers[i].allIn)
                {
                    betLabels[i]?.text = "Bet: " + String(myPlayers[i].bet)
                    moneyLabels[i]?.text = "ALL-IN"
                    betLabels[i]?.textColor = UIColor.red
                    playerLabels[i]?.textColor = UIColor.red
                    moneyLabels[i]?.textColor = UIColor.red
                }
                else if(myPlayers[i].isBetting)
                {
                    betLabels[i]?.text = "Betting: " + String(myPlayers[i].bet)
                    moneyLabels[i]?.text = "Money: " + String(myPlayers[i].money)
                }
                else // folded
                {
                    betLabels[i]?.text = "Bet: " + String(myPlayers[i].bet)
                    moneyLabels[i]?.text = "Money: " + String(myPlayers[i].money)
                    betLabels[i]?.textColor = UIColor.lightGray
                    playerLabels[i]?.textColor = UIColor.lightGray
                    moneyLabels[i]?.textColor = UIColor.lightGray
                }
            }
            else // player doesn't exist
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
