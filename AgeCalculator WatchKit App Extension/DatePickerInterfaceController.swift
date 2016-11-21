//
//  DatePickerInterfaceController.swift
//  AgeCalculator
//
//  Created by Code Falcons mac on 10/26/16.
//  Copyright © 2016 CodeFalcons. All rights reserved.
//

import WatchKit
import Foundation

protocol DatePickerInterfaceControllerDelegate {
    
    func dateSelectedWith(year: Int , month: Int, day: Int)
}

class DatePickerInterfaceController: WKInterfaceController {

//IBOutlets
    @IBOutlet var monthPicker: WKInterfacePicker!
    @IBOutlet var dayPicker: WKInterfacePicker!
    @IBOutlet var yearPicker: WKInterfacePicker!
    
//Data handlers
    var numberOfDays: integer_t = 31 //Default value
    var selectedMonth : Int = 0
    var selectedYear : Int = 0
    var selectedDay : Int = 0
    var years = [Int]()
    
//Delegate
    var delegate: InterfaceController?
    

// MARK: - Interface controller methods
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        self.delegate = context as? InterfaceController
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        selectedMonth = 1 //Default value
        selectedYear = getCurrentYear() - 100 //Default value
        selectedDay = 0 //Default value
        
        setDayPickerItems()
        setMonthPickerItems()
        setYearPickerItems()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
 // MARK: - IBActions
    
    @IBAction func monthPickerItemChanged(_ value: Int) {
        selectedMonth = value + 1
        calculateDays()
    }
    
    @IBAction func dayPickerItemChanged(_ value: Int) {
        selectedDay = value
    }
    
    @IBAction func yearPickerItemChanged(_ value: Int) {
        selectedYear = years[value]
        if selectedMonth == 2 {
            calculateDays()
        }
    }
    
    @IBAction func okBtnTapped() {
        self.delegate?.dateSelectedWith(year: selectedYear , month: selectedMonth, day: selectedDay + 1)
        self.dismiss()
    }

    
// MARK: - Private APIs
    
    func setDayPickerItems()  {
        var days = [Int]()
        
        for day in  1...numberOfDays{
            days.append(Int(day))
        }
        
        let dayPickerItems : [WKPickerItem] = days.map {
            let pickerItem = WKPickerItem()
            pickerItem.title = $0.description
            pickerItem.caption = $0.description
            return pickerItem
        }
        dayPicker.setItems(dayPickerItems)
    }
    
    func calculateDays()  {
        let dateComponents = DateComponents(year: selectedYear, month: selectedMonth)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        numberOfDays = integer_t(range.count)
        setDayPickerItems()
    }
    
    func setMonthPickerItems()  {
        let monthList: [(String, String)] = [   ("January",  "Jan"),
                                                ("February", "Feb"),
                                                ("March",    "Mar"),
                                                ("April",    "Apr"),
                                                ("May",      "May"),
                                                ("June",     "Jun"),
                                                ("July",     "Jul"),
                                                ("August",   "Aug"),
                                                ("September","Sep"),
                                                ("October",  "Oct"),
                                                ("November", "Nov"),
                                                ("December", "Dec")]
        
        let monthPickerItems: [WKPickerItem] = monthList.map {
            let pickerItem = WKPickerItem()
            pickerItem.caption = $0.0
            pickerItem.title = $0.1
            return pickerItem
        }
        monthPicker.setItems(monthPickerItems)
    }
    
    func setYearPickerItems()  {
        let currentYear =  getCurrentYear()
        for year in  currentYear - 100...currentYear{
            years.append(Int(year))
        }
        
        let yearPickerItems : [WKPickerItem] = years.map {
            let pickerItem = WKPickerItem()
            pickerItem.title = $0.description
            pickerItem.caption = $0.description
            return pickerItem
        }
        yearPicker.setItems(yearPickerItems)
    }
    
    func getCurrentYear() -> Int  {
        let date = NSDate()
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day , .month , .year], from: date as Date)
        return components.year!
    }
}
