//
//  InterfaceController.swift
//  AgeCalculator WatchKit App Extension
//
//  Created by Code Falcons mac on 10/26/16.
//  Copyright © 2016 CodeFalcons. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, DatePickerInterfaceControllerDelegate{

//IBOutlets
    @IBOutlet var dateLabel: WKInterfaceDate!
    @IBOutlet var dateOfBirthLabel: WKInterfaceLabel!
    @IBOutlet var ageInYearsLabel: WKInterfaceLabel!
    @IBOutlet var ageInMonthsLabel: WKInterfaceLabel!
    @IBOutlet var ageInDaysLabel: WKInterfaceLabel!
    
//Data handlers
    var selectedMonth : Int = 0
    var selectedYear : Int = 0
    var selectedDay : Int = 0
    var datePickerSelected: Bool = false
    

// MARK: - Interface controller methods
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
// MARK: - IBActions
    
    @IBAction func calculateButtonTapped() {
        if datePickerSelected{
            let date = NSDate()
            let calendar = NSCalendar.current
            let cal =  Calendar(identifier: .gregorian)
            let date1 = cal.date(from: DateComponents(year: selectedYear, month:  selectedMonth, day: selectedDay))!
            let components  = calendar.dateComponents([.day , .month , .year], from: date1, to: date as Date)
            ageInYearsLabel.setText("\(components.year!) years")
            ageInMonthsLabel.setText("\(components.month!) months")
            ageInDaysLabel.setText("\(components.day!) days")
        }
        else{
                dateOfBirthLabel.setAlpha(0.0)
                animate(withDuration: 0.5, animations: {
                    self.dateOfBirthLabel.setAlpha(1.0)
                })
        }
    }

    @IBAction func clearButtonTapped() {
        
        dateOfBirthLabel.setText("Tap here to choose")
        ageInYearsLabel.setText("0 years")
        ageInMonthsLabel.setText("0 months")
        ageInDaysLabel.setText("0 days")
        datePickerSelected = false

    }
    
    @IBAction func dateOfBirthLabelTapped(_ sender: AnyObject) {
        
        self.presentController(withName: "DatePickerInterfaceControllerIdentifier", context: self)
    }

// MARK: - Delegate methods
    
    func dateSelectedWith(year: Int , month: Int, day: Int){
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        let months = dateFormatter.shortMonthSymbols
        let monthSymbol = months![month-1] // month - from your date components
        
        dateOfBirthLabel.setText("\(monthSymbol)/\(day)/\(year)")
        
        selectedMonth = month
        selectedDay = day
        selectedYear = year
        datePickerSelected = true
    }
}
