//
//  MessagesViewController.swift
//  mailbox
//
//  Created by Mike Jacobs on 5/23/15.
//  Copyright (c) 2015 Mike Jacobs. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController{
    
    @IBOutlet weak var menuView: UIImageView!
    @IBOutlet weak var mailboxView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var rightIcon: UIImageView!
    @IBOutlet weak var leftIcon: UIImageView!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var listView: UIImageView!
    @IBOutlet weak var laterView: UIImageView!
    @IBOutlet weak var coverView: UIView!
    
    var menuOriginalX: CGFloat!
    var menuOpenX = CGFloat(260)
    var menuClosedX = CGFloat(-20)
    var messageOriginalX: CGFloat!
    var leftOriginalX: CGFloat!
    var rightOriginalX: CGFloat!
    var swipeRightTrigger1 = CGFloat(60)
    var swipeRightTrigger2 = CGFloat(260)
    var swipeLeftTrigger1 = CGFloat(-60)
    var swipeLeftTrigger2 = CGFloat(-260)
    var shootOffDirection = ""
    var gray = "#E3E3E3"
    var showList = false
    var showLater = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: 320, height: 1280)
        scrollView.setContentOffset(CGPoint(x: 0, y: 37), animated: true)
        
        messageView.backgroundColor = UIColor.lightGrayColor()
        
        messageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "onCustomPan:"))
        listView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onCustomTap:"))
        laterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onCustomTap:"))
        
        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "handleMenuPanning:")
        edgeGesture.edges = UIRectEdge.Left
        mailboxView.addGestureRecognizer(edgeGesture)
        
        coverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "closeMenu:"))
        coverView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handleMenuPanning:"))
        
    }
    func shootOffDirectionAnimation(direction: NSString) {
        if(direction == "left"){
            // right
            leftIcon.alpha = 0
            UIImageView.animateWithDuration(0.3){
                self.messageImageView.frame.origin.x = -self.messageImageView.frame.width
                self.rightIcon.frame.origin.x = -self.messageImageView.frame.width
            }
        } else {
            // left
            rightIcon.alpha = 0
            UIImageView.animateWithDuration(0.3){
                self.messageImageView.frame.origin.x = self.messageImageView.frame.width
                self.leftIcon.frame.origin.x = self.messageImageView.frame.width
            }
        }
        delay(0.3){
            self.collapseMessage()
        }
    }
    func collapseMessage(){
        UIImageView.animateWithDuration(0.3){
            var difference = self.messageView.frame.height
            self.messageView.frame = CGRectMake(self.messageView.frame.origin.x, self.messageView.frame.origin.y, self.messageView.frame.width, 0)
            self.feedImageView.frame = CGRectMake(self.feedImageView.frame.origin.x, self.feedImageView.frame.origin.y - difference, self.feedImageView.frame.width, self.feedImageView.frame.height)
            self.scrollView.contentSize = CGSize(width: 320, height: 1280 - difference)
            
        }
    }
    func onCustomPan(panGestureRecognizer: UIPanGestureRecognizer) {
        var point = panGestureRecognizer.locationInView(view)
        var velocity = panGestureRecognizer.velocityInView(view)
        var translation = panGestureRecognizer.translationInView(view)
        
        
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            
            messageOriginalX = messageImageView.frame.origin.x
            rightOriginalX = rightIcon.frame.origin.x
            leftOriginalX = leftIcon.frame.origin.x
            
            rightIcon.image = UIImage(named: "later_icon")
            leftIcon.image = UIImage(named: "archive_icon")
            
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            
            messageImageView.frame.origin.x =  messageOriginalX + translation.x
            
            if(messageImageView.frame.origin.x > swipeRightTrigger1 && messageImageView.frame.origin.x > 0){
                if(messageImageView.frame.origin.x > swipeRightTrigger2){
                    messageView.backgroundColor = UIColor(rgba: "#EB5433") //red
                    leftIcon.image = UIImage(named: "delete_icon")
                } else{
                    messageView.backgroundColor = UIColor(rgba: "#70D962") //green
                    leftIcon.image = UIImage(named: "archive_icon")
                }
                leftIcon.frame.origin.x = leftOriginalX + translation.x - swipeRightTrigger1
                shootOffDirection = "right"
            } else if(messageImageView.frame.origin.x < swipeLeftTrigger1 && messageImageView.frame.origin.x < 0){
                if(messageImageView.frame.origin.x < swipeLeftTrigger2){
                    messageView.backgroundColor = UIColor(rgba: "#D8A675") //dark yellow
                    rightIcon.image = UIImage(named: "list_icon")
                    showLater = false
                    showList = true
                } else{
                    rightIcon.image = UIImage(named: "later_icon")
                    messageView.backgroundColor = UIColor(rgba: "#FBD333") //yellow
                    showList = false
                    showLater = true
                }
                rightIcon.frame.origin.x = rightOriginalX + translation.x - swipeLeftTrigger1
                shootOffDirection = "left"
            } else if(messageImageView.frame.origin.x > swipeLeftTrigger1 && messageImageView.frame.origin.x < swipeRightTrigger1){
                shootOffDirection = ""
                messageView.backgroundColor = UIColor(rgba: gray)
                showList = false
                showLater = false
            }
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            if(shootOffDirection != ""){
                shootOffDirectionAnimation(shootOffDirection)
                if(showList){
                    UIView.animateWithDuration(0.3){
                        self.listView.alpha = 1
                    }
                } else if(showLater){
                    UIView.animateWithDuration(0.3){
                        self.laterView.alpha = 1
                    }
                }
                
            } else {
                UIView.animateWithDuration(0.3){
                    self.messageImageView.frame.origin.x = self.messageOriginalX
                    self.messageView.backgroundColor = UIColor(rgba: self.gray)
                }
            }
            shootOffDirection = ""
            
        }
    }
    func onCustomTap(tapGestureRecognizer: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.3){
            tapGestureRecognizer.view!.alpha = 0
        }
        
    }

    func handleMenuPanning(panGestureRecognizer: UIPanGestureRecognizer?){
        var point = panGestureRecognizer!.locationInView(view)
        var velocity = panGestureRecognizer!.velocityInView(view)
        var translation = panGestureRecognizer!.translationInView(view)
        
        if panGestureRecognizer!.state == UIGestureRecognizerState.Began {
            menuOriginalX = mailboxView.frame.origin.x
        } else if panGestureRecognizer!.state == UIGestureRecognizerState.Changed {
            mailboxView.frame.origin.x =  menuOriginalX + translation.x
        } else if panGestureRecognizer!.state == UIGestureRecognizerState.Ended {
            if(velocity.x > 0 && mailboxView.frame.origin.x > mailboxView.frame.width / 4){
                self.openMenu()
            } else {
                self.closeMenu()
            }
        }
    }
    func closeMenu(tapGestureRecognizer: UITapGestureRecognizer){
        self.closeMenu()
    }
    
    func closeMenu(){
        self.coverView.alpha = 0
        UIView.animateWithDuration(0.3){
            self.mailboxView.frame.origin.x = self.menuClosedX // - translation.x
        }
    }
    func openMenu(tapGestureRecognizer: UITapGestureRecognizer){
        self.openMenu()
    }
    func openMenu(){
        self.coverView.alpha = 1
        UIView.animateWithDuration(0.3){
            self.mailboxView.frame.origin.x = self.menuOpenX
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
