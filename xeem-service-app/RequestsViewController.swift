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
        getModel()
        tableView.dataSource = self
        tableView.delegate = self
        
    }

    func getModel() {
        let token = User.currentUser?.token
        
        XEEMService.getShopsByOwnerId(token!) { (shops, error) -> Void in
            self.shops = shops
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension RequestsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (shops![section].requests?.count)!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return shops!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("HistoryCell") as! RequestTableViewCell
        
        cell.model = shops[indexPath.section].requests![indexPath.row]
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}
