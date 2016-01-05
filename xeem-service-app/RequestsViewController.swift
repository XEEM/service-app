//
//  ViewController.swift
//  xeem-service-app
//
//  Created by Anh-Tu Hoang on 12/29/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class RequestsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var shops: [ShopModel]!
    var loadedShops: [ShopModel]!
    var timer: NSTimer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self
//        self.getModel()
        self.intervalUpdateModel()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }

    func intervalUpdateModel(){
         timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: "getModel", userInfo: nil, repeats: true)
    }
    
    func getModel() {
        let token = User.currentToken
        XEEMService.sharedInstance.getShopsByOwnerId(token!) { (shops, error) -> Void in
                self.shops = shops
                self.tableView.reloadData()
                print("lalalala")
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
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return shops![section].name
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("RequestCell") as! RequestTableViewCell
        
        cell.model = shops[indexPath.section].requests![indexPath.row]
        cell.indexPath = indexPath
        cell.delegate = self
        cell.setLayout()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    

}

extension RequestsViewController: MGSwipeTableCellDelegate{
    // tap button
    func swipeTableCell(cell: MGSwipeTableCell!, tappedButtonAtIndex index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        let indexPath = tableView.indexPathForCell(cell)
        
        // accept request by swipe from left to right
        if direction == .LeftToRight {
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
            let navigationController = UINavigationController.init(rootViewController: vc)
            
            vc.request = shops[(indexPath?.section)!].requests![(indexPath?.row)!]
            vc.shopModel = shops[(indexPath?.section)!]
            self.navigationController?.presentViewController(navigationController, animated: true, completion: { () -> Void in
                // timer invalidate
                self.timer?.invalidate()
                                
                self.tableView.beginUpdates()
                self.shops[indexPath!.section].requests?.removeAtIndex(indexPath!.row)
                self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
                
                // accept the request
                let requestCell = cell as! RequestTableViewCell
                XEEMService.sharedInstance.acceptRequest(User.currentToken!, requestToken: requestCell.model.id, completion: { (request, error) -> Void in
                    print("accepted request \(request)")
                })
                self.tableView.endUpdates()
            })

            
            return true
        }
        
        return false
    }
}

