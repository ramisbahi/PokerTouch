//
//  ScoreViewController.swift
//  PokerTouch
//
//  Created by Subhi Sbahi on 5/29/17.
//  Copyright © 2017 Rami Sbahi. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {
    
    @IBOutlet weak var Label1: UILabel!
    @IBOutlet weak var Score1: UILabel!
    
    @IBOutlet weak var Label2: UILabel!
    @IBOutlet weak var Score2: UILabel!
    
    @IBOutlet weak var Label3: UILabel!
    @IBOutlet weak var Score3: UILabel!
    
    @IBOutlet weak var Label4: UILabel!
    @IBOutlet weak var Score4: UILabel!
    
    @IBOutlet weak var Label5: UILabel!
    @IBOutlet weak var Score5: UILabel!
    
    @IBOutlet weak var Label6: UILabel!
    @IBOutlet weak var Score6: UILabel!
    
    @IBOutlet weak var Label7: UILabel!
    @IBOutlet weak var Score7: UILabel!
    
    @IBOutlet weak var Label8: UILabel!
    @IBOutlet weak var Score8: UILabel!
    
    @IBOutlet weak var Label9: UILabel!
    @IBOutlet weak var Score9: UILabel!
    
    @IBOutlet weak var BottomLabel: UILabel!
    
    @IBOutlet weak var YesButton: UIButton!
    @IBOutlet weak var NoButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        let labelArray = [Label1, Label2, Label3, Label4, Label5, Label6, Label7, Label8, Label9]
        let scoreArray = [Score1, Score2, Score3, Score4, Score5, Score6, Score7, Score8, Score9]
        
        let playerList = GameViewController.myRunner.sortedPlayers()
        
        for i in 0..<playerList.count
        {
            labelArray[i]?.text = String(i+1) + ". " + playerList[i].myName
            scoreArray[i]?.text = String(playerList[i].money)
        }
        
        GameViewController.myRunner.newRound()
        
        if(GameViewController.myRunner.myPlayers.count == 1)
        {
            BottomLabel.text = "Looks like \(GameViewController.myRunner.myPlayers[0].myName) won!"
            YesButton.isEnabled = false
            NoButton.setTitle("End Game", for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        GameViewController.myRunner.newRound()
        
    }
 

}
