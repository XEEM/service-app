//
//  ViewController.swift
//  xeem-service-app
//
//  Created by Anh-Tu Hoang on 12/29/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import Socket_IO_Client_Swift
import AFNetworking
class RequestsViewController: UIViewController {

    @IBOutlet weak var shopAddressLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var user: User! {
        didSet{
            ownerNameLabel.text = self.user.fullName
            avatarImage.setImageWithURL(user.avatarURL!, placeholderImage: UIImage(named: "profile-placeholder"))
        }
    }
    
    var shops: [ShopModel]!
    var loadedShops: [ShopModel]!
    var timer: NSTimer?
    var requests: [Request]!
    
    let socket = SocketIOClient(socketURL: "http://xeem-push-server.herokuapp.com")
//    let socket = SocketIOClient(socketURL: "localhost:3000")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        user = User.currentUser
        
        requests = [Request]()
        setupColorNavigationBar()
        setupSocket()
        
        tableView.dataSource = self
        tableView.delegate = self
//        self.getModel()
//        self.intervalUpdateModel()
    }
    
    func setupColorNavigationBar(){
        let attrs = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "SanFranciscoDisplay-Medium", size: 18)!
        ]
        
        //let img = UIImage()
        //self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.titleTextAttributes = attrs
        self.navigationController?.navigationBar.barTintColor = UIColor.MKColor.AppPrimaryColor

//        navigationController!.navigationBar.shadowImage = UIImage()
//        navigationController!.navigationBar.barTintColor = UIColor.MKColor.AppMainColor
//        navigationController!.navigationBar.tintColor = UIColor.MKColor.AppMainColor
    }
    
    func setupSocket(){
        self.addHandlers()
        self.socket.connect()
    }
    
    func addHandlers() {
        self.socket.on("hello") {[weak self] data, ack in
            print("Hello event:\(data)")
        }

        self.socket.on("requestSent") { (data, ack) -> Void in
            let requestId = data[0] as! String
            
            print("requestId:\(requestId)")
        }
        
        self.socket.on("requestSent2") { (data, ack) -> Void in
            let data = data[0] as! NSDictionary
            
            let request = Request(dictionary: data)
            self.addNewRequest(request)
            
            print("requestId:\(data)")
        }
        
        self.socket.on("connect") { (data, ack) -> Void in
            print("socket connected")
            self.socket.emit("sendUserId", User.currentToken!)
        }
    }
    
    func addNewRequest(request: Request){
        self.requests.append(request);
        self.tableView.reloadData()
        
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
//        if shops == nil {
//            return 0
//        }
//        
//        return (shops![section].requests?.count)!
        
        return self.requests.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("RequestCell") as! RequestTableViewCell
        
        cell.model = self.requests![indexPath.row]
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
            
            vc.request = requests![(indexPath?.row)!]
            vc.shopModel = vc.request.repairShop
            
            self.navigationController?.presentViewController(navigationController, animated: true, completion: { () -> Void in
                // timer invalidate
                self.timer?.invalidate()
                                
                self.tableView.beginUpdates()
                self.requests.removeAtIndex(indexPath!.row)
//                self.shops[indexPath!.section].requests?.removeAtIndex(indexPath!.row)
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

