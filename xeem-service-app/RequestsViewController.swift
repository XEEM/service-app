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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self

//        intervalUpdateModel()
        getModel()
    }

    func intervalUpdateModel(){
         var timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "getModel", userInfo: nil, repeats: true)
    }
    
    func getModel() {
        let token = User.currentToken
        
        XEEMService.sharedInstance.getShopsByOwnerId(token!) { (shops, error) -> Void in
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
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return shops![section].name
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("RequestCell") as! RequestTableViewCell
        
        cell.model = shops[indexPath.section].requests![indexPath.row]
        cell.indexPath = indexPath
        cell.delegate = self
        setCellButtons(cell)
        
        return cell
    }
    
    func setCellButtons(cell: RequestTableViewCell){
        cell.leftButtons = [MGSwipeButton(title: "Accept", backgroundColor: UIColor.greenColor())]
        cell.leftExpansion.fillOnTrigger = true
        cell.leftExpansion.buttonIndex = 0
        cell.leftSwipeSettings.transition = MGSwipeTransition.Drag
        //configure right buttons
        cell.rightButtons = [MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor())
            ,MGSwipeButton(title: "More",backgroundColor: UIColor.lightGrayColor())]
        cell.rightSwipeSettings.transition = MGSwipeTransition.Rotate3D
//        cell.rightExpansion.buttonIndex = 0
//        cell.rightExpansion.fillOnTrigger = true
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
            tableView.beginUpdates()
            shops[indexPath!.section].requests?.removeAtIndex(indexPath!.row)
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            
            // accept the request
            let requestCell = cell as! RequestTableViewCell
            XEEMService.sharedInstance.acceptRequest(User.currentToken!, requestToken: requestCell.model.id, completion: { (request, error) -> Void in
                print("accepted request \(request)")
            })
            tableView.endUpdates()
            return true
        }
        
        return false
    }
}

