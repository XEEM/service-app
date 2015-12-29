//
//  ViewController.swift
//  xeem-service-app
//
//  Created by Anh-Tu Hoang on 12/29/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import UIKit

class RequestsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var shops: [ShopModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self
        intervalUpdateModel()
    }

    func intervalUpdateModel(){
         var timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "getModel", userInfo: nil, repeats: true)
    }
    
    
    func getModel() {
        let token = User.currentToken
        
        XEEMService.getShopsByOwnerId(token!) { (shops, error) -> Void in
            self.shops = shops
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension RequestsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shops == nil {
            return 0
        }
        
        return (shops![section].requests?.count)!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if shops == nil {
            return 0
        }
        
        return shops!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("RequestCell") as! RequestTableViewCell
        
        cell.model = shops[indexPath.section].requests![indexPath.row]
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}
