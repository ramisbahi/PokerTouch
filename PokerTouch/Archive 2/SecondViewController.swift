//
//  SecondViewController.swift
//  PokerTouch
//
//  Created by Subhi Sbahi on 5/28/17.
//  Copyright © 2017 Rami Sbahi. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var PlayerOneLabel: UILabel!
    let playerOne: String = ViewController.playerNames[0]
    
    
    @IBAction func BeginButtonPressed(_ sender: Any)
    {
        performSegue(withIdentifier: "segue2", sender: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        PlayerOneLabel.text = playerOne
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
