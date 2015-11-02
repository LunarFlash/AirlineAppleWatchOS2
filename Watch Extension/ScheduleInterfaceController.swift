//
//  ScheduleInterfaceController.swift
//  AirAber
//
//  Created by Terry Wang on 10/31/15.
//  Copyright © 2015 Mic Pringle. All rights reserved.
//

import WatchKit
import Foundation


class ScheduleInterfaceController: WKInterfaceController {

    
    @IBOutlet var flightsTable: WKInterfaceTable!
    
    
    var flights = Flight.allFlights()  // array of Flight objects
    var selectedIndex = 0 // use this to remember which table row was selected when presenting the two interface controllers.
    
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        flightsTable.setNumberOfRows(flights.count, withRowType: "FlightRow")
        
        for index in 0..<flightsTable.numberOfRows {
            if let controller = flightsTable.rowControllerAtIndex(index) as? FlightRowController {
                controller.flight = flights[index]
            }
        }
        
    }
    
    override func didAppear() {
        super.didAppear()
        // 1  check to see if the selected flight is checked-in, and if so you try and cast the row controller at the corresponding index in the table to an instance of FlightRowController.
        if flights[selectedIndex].checkedIn, let controller = flightsTable.rowControllerAtIndex(selectedIndex) as? FlightRowController {
            // 2 If that succeeds, you use the new animation API on WKInterfaceController to execute the given closure, over a duration of 0.35 seconds.
            animateWithDuration(0.35, animations: { () -> Void in
                // 3 you call the method you just added to FlightRowController, which changes the color of the plane image and separator of that table row, and provides the user with some visual feedback that they’re now checked-in.
                controller.updateForCheckIn()
            })
        }
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        // retrieve the appropriate flight from flights using rowIndex, create an array containing the identifiers of the two interface controllers you want to present, and then present them, passing flight as the context to both.
        let flight = flights[rowIndex]
        let controllers = flight.checkedIn ? ["Flight", "BoardingPass"] : ["Flight", "CheckIn"]
        selectedIndex = rowIndex
        presentControllerWithNames(controllers, contexts:[flight, flight])
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
