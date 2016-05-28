//
//  ViewController.swift
//  Messaging Application
//
//  Created by Jared Walton on 5/28/16.
//  Copyright © 2016 Jared Walton. All rights reserved.
//

import UIKit


// globals. sad face :'(
var chatRoom: String = " "
var userName: String = " "

class ViewController: UIViewController {
    
    // socket io
    let socket = SocketIOClient(socketURL: NSURL(string: "http://localhost:8080")!, options: [.Log(true), .ForcePolling(true)])
    socket.on("connect") {data, ack in
        print("socket connected")
    }
    
    socket.on("currentAmount") {data, ack in
        if let cur = data[0] as? Double {
            socket.emitWithAck("canUpdate", cur)(timeoutAfter: 0) {data in
                socket.emit("update", ["amount": cur + 2.50])
            }
            ack.with("Got your currentAmount", "dude")
        }
    }
    
    socket.connect()
    
    // data :)
    var input: String = " "
    var newView: String = " "
    var message: String = " "
    
    // link all the text input fields
    @IBOutlet var chatRoomInput: UITextField!
    @IBOutlet var userNameInput: UITextField!
    @IBOutlet var infoDisplay: UILabel!
    @IBOutlet var messageInputField: UITextField!
    @IBOutlet var messageField: UITextView!
    
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
                updateMessage()
                break
            default:
                changeViews()
                break
        }
    }
    
    func updateMessage() {
        message = chatRoom + " - " + userName + ": " + messageInputField.text! + "\n"
        messageField.text = messageField.text.stringByAppendingString(message)
        messageInputField.text = ""
    }
    
    func recieveMessage(user: String, userMessage: String) {
         message = chatRoom + " - " + user + ": " + userMessage + "\n"
         messageField.text = messageField.text.stringByAppendingString(message)
    }
    
    func changeViews() {
        if (input == "Submit Chat") { newView = "UserName" }
        else if (input == "Submit Name") { newView = "ChatRoom" }
        else if (input == "New Room") { newView = "EnterChatRoom" }
        else if (input == "New User Name") { newView = "UserName" }
        else { }
        let viewController : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier(newView)
        self.showViewController(viewController as! UIViewController, sender: viewController)
    }
}
