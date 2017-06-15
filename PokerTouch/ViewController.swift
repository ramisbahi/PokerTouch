//
//  ViewController.swift
//  PokerTouch
//
//  Created by Reema Hannan on 5/25/17.
//  Copyright © 2017 Rami Sbahi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    static var numPlayers: Int = 0
    var count = 1
    static var playerNames: [String] = []
    static var newGame = true
    
    @IBOutlet weak var UserTextField: UITextField!
    @IBOutlet weak var UserLabel: UILabel!
    @IBOutlet weak var PlayerTextField: UITextField!
    @IBOutlet weak var EnterButton: UIButton!
    
    @IBAction func Button(_ sender: Any) {
        let amount = Int(UserTextField.text!)!
        if(amount <= 9 && amount >= 2)
        {
            ViewController.numPlayers = amount
        }
        else
        {
            let alert = UIAlertController(title: "Please enter a value between 2 and 9", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
   
    @IBAction func PlayerButtonEntered(_ sender: Any)
    {
        ViewController.playerNames.append(PlayerTextField.text!)
        PlayerTextField.text = ""
        count += 1
        if(count <= Int(ViewController.numPlayers))
        {
            UserLabel.text = "Enter Player \(count)'s Name:"
            if(count == Int(ViewController.numPlayers))
            {
                EnterButton.setTitle("Continue", for: .normal)
            }
        }
        else
        {
            ViewController.newGame = true
            self.performSegue(withIdentifier: "segue", sender: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        ViewController.playerNames = []
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

