//
//  CheckInInterfaceController.swift
//  AirAber
//
//  Created by Terry Wang on 11/1/15.
//  Copyright © 2015 Mic Pringle. All rights reserved.
//

import WatchKit
import Foundation


class CheckInInterfaceController: WKInterfaceController {
    
    @IBOutlet var backgroundGroup: WKInterfaceGroup!
    @IBOutlet var originLabel: WKInterfaceLabel!
    @IBOutlet var destinationLabel: WKInterfaceLabel!
    // When the observer is fired, you try to unwrap flight, and if that succeeds you use flight to configure the two labels.
    var flight: Flight? {
        didSet {
            if let flight = flight {
                originLabel.setText(flight.origin)
                destinationLabel.setText(flight.destination)
            }
        }
    }
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        //  try to unwrap and cast context to an instance of Flight, and if that succeeds you use it to set self.flight, which in-turn triggers the property observer and configures the interface.
        if let flight = context as? Flight {
            self.flight = flight
        }
    }
    
    @IBAction func checkInButtonTapped() {
        // Create two constants: one for the duration of the animation, and one for the delay after which the controller will be dismissed. Instead of being a Double, delay is an instance of dispatch_time_t since you’ll be using it with Grand Central Dispatch.
        let duration = 0.35
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64((duration + 0.15) * Double(NSEC_PER_SEC)))
        // Load a sequence of images named Progress and set them as the background image of backgroundGroup. Remember that layout groups conform to WKImageAnimatable, which allows you to use them to play back animated image sequences.
        backgroundGroup.setBackgroundImageNamed("Progress")
        //   begin playback of the image sequence. The range you supply covers the entire sequence, and a repeat count of 1 means the animation will play just once.
        backgroundGroup.startAnimatingWithImagesInRange(NSRange(location: 0, length: 10), duration: duration, repeatCount: 1)
        //  Use Grand Central Dispatch to execute the closure after the given delay.
        dispatch_after(delay, dispatch_get_main_queue()) { () -> Void in
            // Mark flight as checked-in, and then dismiss the controller.
            self.flight?.checkedIn = true
            self.dismissController()
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

}
