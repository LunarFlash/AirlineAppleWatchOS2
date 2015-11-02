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
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        // retrieve the appropriate flight from flights using rowIndex, create an array containing the identifiers of the two interface controllers you want to present, and then present them, passing flight as the context to both.
        let flight = flights[rowIndex]
        let controllers = ["Flight", "CheckIn"]
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
