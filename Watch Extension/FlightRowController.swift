//
//  FlightRowController.swift
//  AirAber
//
//  Created by Terry Wang on 10/31/15.
//  Copyright © 2015 Mic Pringle. All rights reserved.
//

import WatchKit

class FlightRowController: NSObject {
    
    @IBOutlet var separator: WKInterfaceSeparator!
    @IBOutlet var originLabel: WKInterfaceLabel!
    @IBOutlet var destinationLabel: WKInterfaceLabel!
    @IBOutlet var flightNumberLabel: WKInterfaceLabel!
    @IBOutlet var statusLabel: WKInterfaceLabel!
    @IBOutlet var planeImage: WKInterfaceImage!
    
    // optional property
    var flight: Flight? {
        // property observer triggered whenever property is set
        didSet {
            // return if flight is nil
            guard let flight = flight else {
                return
            }
            originLabel.setText(flight.origin)
            destinationLabel.setText(flight.destination)
            flightNumberLabel.setText(flight.number)
            // If the flight is delayed then we change the text colour of the label to red and update the text accordingly.
            if flight.onSchedule {
                statusLabel.setText("On Time")
            } else {
                statusLabel.setText("Delayed")
                statusLabel.setTextColor(UIColor.redColor())
            }
        }
    }
    
    
}
