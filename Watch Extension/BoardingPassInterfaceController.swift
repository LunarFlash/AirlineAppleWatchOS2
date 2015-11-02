//
//  BoardingPassInterfaceController.swift
//  AirAber
//
//  Created by Terry Wang on 11/1/15.
//  Copyright © 2015 Mic Pringle. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class BoardingPassInterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var originLabel: WKInterfaceLabel!
    @IBOutlet var destinationLabel: WKInterfaceLabel!
    @IBOutlet var boardingPassImage: WKInterfaceImage!
    
    var flight: Flight? {
        didSet {
            if let flight = flight {
                originLabel.setText(flight.origin)
                destinationLabel.setText(flight.destination)
                // call showBoardingPass() only if flight already has a boarding pass.
                if let _ = flight.boardingPass {
                    showBoardingPass()
                }
            }
        }
    }
    
    // All communication between the two devices, your watch and phone, is handled by WCSession; you don’t instantiate an instance of this class yourself, rather you use a singleton provided by the framework.
    
    // Added a property observer that, when triggered, attempts to unwrap session. If that succeeds then it sets the session’s delegate before activating it.
    var session: WCSession? {
        didSet {
            if let session = session {
                // Even though you won’t be implementing any of the delegate methods in this class, you’re still required to set the delegate prior to activating the session, otherwise things get a bit unpredictable.
                session.delegate = self
                session.activateSession()
            }
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if let flight = context as? Flight { self.flight = flight }
    }
    
    override func didAppear() {
        super.didAppear()
        // 1 If you have a valid flight that has no boarding pass, and Watch Connectivity is supported, then you move onto sending the message. You should always check to see if Watch Connectivity is supported before attempting any communication with the paired phone.
        if let flight = flight where flight.boardingPass == nil && WCSession.isSupported() {
            // 2 You set session to the default session singleton. This in-turn triggers the property observer, setting the session’s delegate before activating it.
            session = WCSession.defaultSession()
            // 3 You fire off the message to the companion iPhone app. You include a dictionary containing the flight reference that will be forwarded to the iPhone app, and provide both reply and error handlers.
            session!.sendMessage(["reference": flight.reference], replyHandler: { (response) -> Void in
                // 4 The reply handler receives a dictionary, and is called by the iPhone app. You first try to extract the image data of the boarding pass from the dictionary, before attempting to create an instance of UIImage with it.
                if let boardingPassData = response["boardingPassData"] as? NSData, boardingPass = UIImage(data: boardingPassData) {
                    // 5 If that succeeds, you set the image as the flight’s boarding pass, and then jump over to the main queue where you call showBoardingPass() to show it to the user. The reply and error handlers are called on a background queue, so if you need to update the interface, as you are here, then always make sure to jump to the main queue before doing so.
                    flight.boardingPass = boardingPass
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.showBoardingPass()
                    })
                }
                }, errorHandler: { (error) -> Void in
                    // 6 If the message sending fails then you simply print the error to the console.
                    print(error)
            })
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // This will be called from two places – from within the property observer of flight if the flight already has a boarding pass, and from within the reply handler of the message you fire off to the iPhone. The implementation is pretty straightforward – you stop the image animating, increase the size of the image, and then set the image being displayed to the boarding pass.
    
    private func showBoardingPass() {
        boardingPassImage.stopAnimating()
        boardingPassImage.setWidth(120)
        boardingPassImage.setHeight(120)
        boardingPassImage.setImage(flight?.boardingPass)
    }

}
