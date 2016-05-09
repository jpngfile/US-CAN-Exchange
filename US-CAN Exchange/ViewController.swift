//
//  ViewController.swift
//  US-CAN Exchange
//
//  Created by Jason P'ng on 2016-05-05.
//  Copyright © 2016 Jason P'ng. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let currencies : [String] = ["CAD","US"]
    var currencyRates : [String : Double] = [:]
    var tableView : UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let tableFrame : CGRect = CGRect (x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        self.tableView = UITableView (frame : tableFrame)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.view.addSubview(tableView!)
        
        view.addSubview(UIView (frame: CGRect (x: 0, y: 0, width: 50, height: 50)))
        
        retrieveExchangeRates("USD")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            cell = UITableViewCell (style: .Default, reuseIdentifier: "cell")
        }
        let rate = currencyRates [currencies[indexPath.row]] ?? -1
        cell?.textLabel?.text = "\(currencies[indexPath.row]) \(rate > 0 ? String (rate) : "Can't find data")"
        return cell!
    }
    
    //updates the currencyRates dictionary
    func retrieveExchangeRates (currency : String){
        RestAPIManager.sharedInstance.getExchangeRates{json in
            let rates = json ["rates"]
            for currency in self.currencies {
                if let rate = rates[currency].double {
                    self.currencyRates [currency] = rate;
                }
                else{
                    self.currencyRates[currency] = nil;
                }
            }
            dispatch_async(dispatch_get_main_queue(),{
                self.tableView?.reloadData()
            })
        }
        
    }

}

