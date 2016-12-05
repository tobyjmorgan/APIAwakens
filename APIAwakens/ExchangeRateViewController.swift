//
//  ExchangeRateViewController.swift
//  APIAwakens
//
//  Created by redBred LLC on 12/4/16.
//  Copyright © 2016 redBred. All rights reserved.
//

import UIKit

class ExchangeRateViewController: UIViewController {

    @IBOutlet var exchangeRate: UITextField!
    
    @IBAction func onDone() {
        
        if let rateAsString = exchangeRate.text,
            let rate = Double(rateAsString),
            rate > 0.0 {
            
            let defaults = UserDefaults.standard
            defaults.set(rate, forKey: DefaultKeys.exchangeRate)
            delegate?.onDismissExchangeRateVC()

        } else {
        
            showAlert()
        }
    }
    
    var delegate: ExchangeRateViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let defaults = UserDefaults.standard
        exchangeRate.text = "\(defaults.double(forKey: DefaultKeys.exchangeRate))"
    }

    // Thanks to Michael Garito on StackOverflow for this
    // http://stackoverflow.com/questions/29209453/how-to-hide-a-navigation-bar-from-first-viewcontroller-in-swift
    override func viewWillAppear(_ animated: Bool) {
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "That Won't Fly", message: "Sorry, that's not a valid exchange rate. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Oh, alright!", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)

    }
}
