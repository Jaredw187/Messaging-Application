//
//  ViewController.swift
//  Messaging Application
//
//  Created by Jared Walton on 5/28/16.
//  Copyright © 2016 Jared Walton. All rights reserved.
//

import UIKit

// adding an extension for scrolling capabilties
extension UITextView {
    func moveTextUp() {
        let length = NSMakeRange((text as NSString).length - 1, 0);
        scrollRangeToVisible(length);
    }
}

// globals. sad face :'(
var chatRoom: String = "r"
var userName: String = "Jared"

class ViewController: UIViewController {
    
    let socket = SocketIOClient(socketURL: NSURL(string: "http://127.0.0.1:5000")!, options: [.Log(true), .ForcePolling(true)])
    
    func addHandlers() {
        
        socket.on("connect") {data, ack in
            print("connected")
            self.socket.emit("join", ["room":chatRoom])
        }
        socket.on("newMessage") { data, ack in
            print("got it")
            self.recieveMessage(String(data[0]))
        }
        socket.connect()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        addHandlers()
        self.messageField?.layoutManager.allowsNonContiguousLayout = false
    }
    
    // data
    var input: String = " "
    var newView: String = " "
    var message: String = " "
    
    // link all the text input fields
    @IBOutlet var chatRoomInput: UITextField!
    @IBOutlet var userNameInput: UITextField!
    @IBOutlet var infoDisplay: UILabel!
    @IBOutlet var messageInputField: UITextField!
    @IBOutlet var messageField: UITextView?
    @IBOutlet var roomLabel: UILabel!
    
    // obtain user input with buttons
    @IBAction func getInput(sender: AnyObject) {

        input = ((sender as! UIButton).titleLabel!.text!);
        switch input {
            case "Submit Chat":
                if (chatRoomInput.text == "") { return }
                else { chatRoom = chatRoomInput.text!; changeViews() }
                break
            case "Submit Name":
                if (userNameInput.text == "") { return }
                else { userName = userNameInput.text!; changeViews() }
                break
            case "Submit":
                getMessage()
                break
            default:
                changeViews()
                break
        }
    }
    
    func getMessage() {
        message = chatRoom + " - " + userName + ": " + messageInputField.text!
        messageInputField.text = ""
        socket.emit("newMessage", ["message":message, "room":chatRoom])
        
    }
    
    func recieveMessage(msg: String) {
        // remove the braces from socket io 
//        var _msg = String(msg.characters.dropFirst())
//        _msg = String(_msg.characters.dropLast())
        messageField?.text = messageField?.text.stringByAppendingString(msg + "\n")
        messageField?.moveTextUp()
    }
    // set the correct view depending on input from user
    func changeViews() {
        if (input == "Submit Chat") { newView = "UserName" }
        else if (input == "Submit Name") { newView = "ChatRoom" }
        else if (input == "New Room") { newView = "EnterChatRoom" }
        else if (input == "New User Name") { newView = "UserName" }
        else { /* do nothing */ }
        let viewController : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier(newView)
        self.showViewController(viewController as! UIViewController, sender: viewController)
    }
    
    // show the keyboard and move the display up
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    // hide the keyboard and move the display back down
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
}
