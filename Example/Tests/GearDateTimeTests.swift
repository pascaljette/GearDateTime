//
//  GearDateTimeTests.swift
//  GearDateTimeTests
//
//  Created by Pascal Jette on 2016/11/03.
//  Copyright © 2016 Pascal Jette. All rights reserved.
//

import XCTest
@testable import GearDateTime

class GearDateTimeTests: XCTestCase {
    
    let today: GearDateTime = GearDateTime()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInvalidComponentsInit() {
        
        let components = DateComponents()
        
        do {
            
            let _ = try GearDateTime(components: components)
            XCTFail("Components without a calendar cannot be used.")
        } catch (let error) {
            
            XCTAssertTrue(error is GearDateTimeError)
        }
    }
    
    func testManualComponentsInit() {
        
        var dateTime = try! GearDateTime(string: "2016-07-18T09:23:34+00:00", format: GearDateTime.CommonFormats.iso8601Timestamp.rawValue)
        
        dateTime.timeZone = TimeZone(abbreviation: "UTC")!
        XCTAssertEqual(dateTime.day, 18)
        XCTAssertEqual(dateTime.month, 7)
        XCTAssertEqual(dateTime.year, 2016)

        XCTAssertEqual(dateTime.hour, 9)
        XCTAssertEqual(dateTime.minute, 23)
        XCTAssertEqual(dateTime.seconds, 34)
    }
    
    func testMismatchesFormat() {
        
        do {
            
            let _ = try GearDateTime(string: "01-02-2015", format: "yyyy-MM-dd")
            XCTFail("Mismatched string/format should throw an error.")
            
        } catch (let error) {
            
            XCTAssertTrue(error is GearDateTimeError)
        }
    }
    
    func testSetComponentsManually() {
        
        var dateTime = GearDateTime()
        
        dateTime.day = 1
        XCTAssertEqual(dateTime.day, 1)
        XCTAssertEqual(dateTime.month, today.month)
        XCTAssertEqual(dateTime.year, today.year)

        dateTime.month = 3
        XCTAssertEqual(dateTime.day, 1)
        XCTAssertEqual(dateTime.month, 3)
        XCTAssertEqual(dateTime.year, today.year)

        dateTime.year = 2000
        XCTAssertEqual(dateTime.day, 1)
        XCTAssertEqual(dateTime.month, 3)
        XCTAssertEqual(dateTime.year, 2000)
    }
    
    func testDateForFirstDayOfMonth() {
        
        var dateTime = try! GearDateTime.dateForFirstDayOfYearMonth(year: today.year, month: today.month)
        
        // Today
        XCTAssertEqual(dateTime.day, 1)
        XCTAssertEqual(dateTime.month, today.month)
        XCTAssertEqual(dateTime.year, today.year)
        
        // Next month
        dateTime = try! GearDateTime.dateForFirstDayOfYearMonth(year: today.year, month: today.month + 1)
        XCTAssertEqual(dateTime.day, 1)
        XCTAssertEqual(dateTime.month, today.month + 1)
        XCTAssertEqual(dateTime.year, today.year)

        // Previous month
        dateTime = try! GearDateTime.dateForFirstDayOfYearMonth(year: today.year, month: today.month - 1)
        XCTAssertEqual(dateTime.day, 1)
        XCTAssertEqual(dateTime.month, today.month - 1)
        XCTAssertEqual(dateTime.year, today.year)
        
        // Last day of February (leap year)
        dateTime = try! GearDateTime.dateForLastDayOfYearMonth(year: 2016, month: 2)
        XCTAssertEqual(dateTime.day, 29)
        XCTAssertEqual(dateTime.month, 2)
        XCTAssertEqual(dateTime.year, 2016)

        // Last day of February (non-leap year)
        dateTime = try! GearDateTime.dateForLastDayOfYearMonth(year: 2015, month: 2)
        XCTAssertEqual(dateTime.day, 28)
        XCTAssertEqual(dateTime.month, 2)
        XCTAssertEqual(dateTime.year, 2015)
    }
    
    func testDateForLastDayOfMonth() {
        
        var dateTime = try! GearDateTime.dateForFirstDayOfYearMonth(year: today.year, month: today.month)
        
        // Last day of April
        dateTime = try! GearDateTime.dateForLastDayOfYearMonth(year: 2016, month: 4)
        XCTAssertEqual(dateTime.day, 30)
        XCTAssertEqual(dateTime.month, 4)
        XCTAssertEqual(dateTime.year, 2016)

        // Last day of December
        dateTime = try! GearDateTime.dateForLastDayOfYearMonth(year: 2016, month: 12)
        XCTAssertEqual(dateTime.day, 31)
        XCTAssertEqual(dateTime.month, 12)
        XCTAssertEqual(dateTime.year, 2016)
        
        // Last day of February (leap year)
        dateTime = try! GearDateTime.dateForLastDayOfYearMonth(year: 2016, month: 2)
        XCTAssertEqual(dateTime.day, 29)
        XCTAssertEqual(dateTime.month, 2)
        XCTAssertEqual(dateTime.year, 2016)
        
        // Last day of February (non-leap year)
        dateTime = try! GearDateTime.dateForLastDayOfYearMonth(year: 2015, month: 2)
        XCTAssertEqual(dateTime.day, 28)
        XCTAssertEqual(dateTime.month, 2)
        XCTAssertEqual(dateTime.year, 2015)
    }
    
    func testAllDaysForMonthInNonLeapYear() {
        
        for month in 1...12 {
            
            let dateTimeArray = try! GearDateTime.allDaysFor(year: 2015, month: month)
            
            for(index, dateTime) in dateTimeArray.enumerated() {
                
                XCTAssertEqual(dateTime.day, index + 1)
                XCTAssertEqual(dateTime.month, month)
                XCTAssertEqual(dateTime.year, 2015)
            }
        }
    }
    
    func testAllDaysForMonthInLeapYear() {
        
        for month in 1...12 {
            
            let dateTimeArray = try! GearDateTime.allDaysFor(year: 2016, month: month)
            
            for(index, dateTime) in dateTimeArray.enumerated() {
                
                XCTAssertEqual(dateTime.day, index + 1)
                XCTAssertEqual(dateTime.month, month)
                XCTAssertEqual(dateTime.year, 2016)
            }
        }
    }
    
    // February 2015 starts on Sunday and ends on Saturday, so there should be 
    // no difference incurred by completing the weeks.
    func testeAllDaysWithCompleteWeeksBasic() {
        
        let dateTimeArray = try! GearDateTime.allDaysWithCompleteWeeksFor(year: 2015, month: 2)
        
        XCTAssertEqual(dateTimeArray.count, 28)
        
        for(index, dateTime) in dateTimeArray.enumerated() {
            
            XCTAssertEqual(dateTime.day, index + 1)
            XCTAssertEqual(dateTime.month, 2)
            XCTAssertEqual(dateTime.year, 2015)
        }
    }
    
    func testeAllDaysWithCompleteWeeksEndOfYear() {

        let dateTimeArray = try! GearDateTime.allDaysWithCompleteWeeksFor(year: 2015, month: 12)
        
        XCTAssertEqual(dateTimeArray.count, 35)
        
        for(index, dateTime) in dateTimeArray.enumerated() {
            
            if index < 2 {
                
                XCTAssertEqual(dateTime.day, index + 29)
                XCTAssertEqual(dateTime.month, 11)
                XCTAssertEqual(dateTime.year, 2015)
                
            } else if index <= 32 {
                
                XCTAssertEqual(dateTime.day, index - 1)
                XCTAssertEqual(dateTime.month, 12)
                XCTAssertEqual(dateTime.year, 2015)
                
            } else {
                
                XCTAssertEqual(dateTime.day, index - 32)
                XCTAssertEqual(dateTime.month, 1)
                XCTAssertEqual(dateTime.year, 2016)
            }
        }
    }
    
    func testIncrementYear() {
        
        var dateTime = try! GearDateTime(string: "2015-12-02", format: "yyyy-MM-dd")
        
        dateTime.year += 1
        
        XCTAssertEqual(dateTime.day, 2)
        XCTAssertEqual(dateTime.month, 12)
        XCTAssertEqual(dateTime.year, 2016)

        dateTime.year -= 2

        XCTAssertEqual(dateTime.day, 2)
        XCTAssertEqual(dateTime.month, 12)
        XCTAssertEqual(dateTime.year, 2014)
    }
    
    func testIncrementMonth() {
        
        var dateTime = try! GearDateTime(string: "2015-12-02", format: "yyyy-MM-dd")
        
        dateTime.month += 1
        
        XCTAssertEqual(dateTime.day, 2)
        XCTAssertEqual(dateTime.month, 1)
        XCTAssertEqual(dateTime.year, 2016)
        
        dateTime.month -= 2
        
        XCTAssertEqual(dateTime.day, 2)
        XCTAssertEqual(dateTime.month, 11)
        XCTAssertEqual(dateTime.year, 2015)
    }

    func testIncrementDay() {
        
        var dateTime = try! GearDateTime(string: "2015-12-02", format: "yyyy-MM-dd")
        
        dateTime.day += 30
        
        XCTAssertEqual(dateTime.day, 1)
        XCTAssertEqual(dateTime.month, 1)
        XCTAssertEqual(dateTime.year, 2016)
        
        dateTime.day -= 61
        
        XCTAssertEqual(dateTime.day, 1)
        XCTAssertEqual(dateTime.month, 11)
        XCTAssertEqual(dateTime.year, 2015)
    }
    
    func testIncrementHours() {
        
        var dateTime = try! GearDateTime(string: "2016-07-18T09:23:34+00:00", format: GearDateTime.CommonFormats.iso8601Timestamp.rawValue)
        
        // By default, the dateTime is set to the current time zone.
        // We want to match the timezone from our string.
        dateTime.timeZone = TimeZone(abbreviation: "UTC")!
        dateTime.hour += 21
        
        XCTAssertEqual(dateTime.day, 19)
        XCTAssertEqual(dateTime.month, 7)
        XCTAssertEqual(dateTime.year, 2016)
        
        XCTAssertEqual(dateTime.hour, 6)
        XCTAssertEqual(dateTime.minute, 23)
        XCTAssertEqual(dateTime.seconds, 34)

        dateTime.hour -= 4
        
        XCTAssertEqual(dateTime.day, 19)
        XCTAssertEqual(dateTime.month, 7)
        XCTAssertEqual(dateTime.year, 2016)
        
        XCTAssertEqual(dateTime.hour, 2)
        XCTAssertEqual(dateTime.minute, 23)
        XCTAssertEqual(dateTime.seconds, 34)
    }

    func testIncrementMinutes() {
        
        var dateTime = try! GearDateTime(string: "2016-07-18T09:23:34+00:00", format: GearDateTime.CommonFormats.iso8601Timestamp.rawValue)
        
        // By default, the dateTime is set to the current time zone.
        // We want to match the timezone from our string.
        dateTime.timeZone = TimeZone(abbreviation: "UTC")!
        dateTime.minute += 8
        
        XCTAssertEqual(dateTime.day, 18)
        XCTAssertEqual(dateTime.month, 7)
        XCTAssertEqual(dateTime.year, 2016)
        
        XCTAssertEqual(dateTime.hour, 9)
        XCTAssertEqual(dateTime.minute, 31)
        XCTAssertEqual(dateTime.seconds, 34)
        
        dateTime.minute -= 121
        
        XCTAssertEqual(dateTime.day, 18)
        XCTAssertEqual(dateTime.month, 7)
        XCTAssertEqual(dateTime.year, 2016)
        
        XCTAssertEqual(dateTime.hour, 7)
        XCTAssertEqual(dateTime.minute, 30)
        XCTAssertEqual(dateTime.seconds, 34)

    }

    func testIncrementSeconds() {
        
        var dateTime = try! GearDateTime(string: "2016-07-18T09:23:34+00:00", format: GearDateTime.CommonFormats.iso8601Timestamp.rawValue)
        
        // By default, the dateTime is set to the current time zone.
        // We want to match the timezone from our string.
        dateTime.timeZone = TimeZone(abbreviation: "UTC")!
        dateTime.seconds += 26
        
        XCTAssertEqual(dateTime.day, 18)
        XCTAssertEqual(dateTime.month, 7)
        XCTAssertEqual(dateTime.year, 2016)
        
        XCTAssertEqual(dateTime.hour, 9)
        XCTAssertEqual(dateTime.minute, 24)
        XCTAssertEqual(dateTime.seconds, 0)
        
        dateTime.seconds -= 1
        
        XCTAssertEqual(dateTime.day, 18)
        XCTAssertEqual(dateTime.month, 7)
        XCTAssertEqual(dateTime.year, 2016)
        
        XCTAssertEqual(dateTime.hour, 9)
        XCTAssertEqual(dateTime.minute, 23)
        XCTAssertEqual(dateTime.seconds, 59)
    }
}
