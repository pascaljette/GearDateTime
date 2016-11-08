// The MIT License (MIT)
//
// Copyright (c) 2015 pascaljette
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

/// Wrapper/shortcut around the Calendar/Date combination to make date handling easy.
public struct GearDateTime {
  
    //
    // MARK: Stored properties
    //

    /// Reference on the calendar to compute date and components.
    fileprivate var calendar: Calendar
    
    /// Reference on the current date.
    public var date: Date
    
    //
    // MARK: Initialization
    //
    
    /// Initialize with an existing date.
    ///
    /// - parameter date: Date with which to initialize.  Defaults to today.
    /// - parameter calendar: Calendar with which to initialize.  Defaults to the current calendar.
    public init(date: Date = Date(), calendar: Calendar = Calendar.current) {
        
        self.date = date
        self.calendar = Calendar.current
    }
    
    /// Initialize with components.  Assume that the calendar contain a calendar, otherwise will throw an exception.
    ///
    /// - parameter components: Components with which to initialize.  Must contain a calendar.
    ///
    /// - throws: A DateTimeError.InvalidDateComponents error if a date cannot be formed from the components.
    public init(components: DateComponents) throws {
    
        guard let componentsDate = components.date else {
            
            throw GearDateTimeError.invalidDateComponents(year: components.year, month: components.month, day: components.day)
        }
        
        self.calendar = components.calendar ?? Calendar.current
        self.date = componentsDate
    }
    
    /// Init with a date formatter.
    ///
    /// - parameter string: Date to parse in string format.
    /// - parameter dateFormatter: Formatter to use to parse the date.
    /// - parameter calendar: Calendar used to assign to the date.
    ///
    /// - throws: DateTimeError.InvalidDateFormat if a date cannot be parsed with the provided formatter.
    public init(string: String, dateFormatter: DateFormatter, calendar: Calendar = Calendar.current) throws {
        
        self.calendar = calendar
        
        // Save the formatter in the cache
        GearDateFormatterCache.addFormatter(dateFormatter)
        
        guard let parsedDate = dateFormatter.date(from: string) else {
            
            throw GearDateTimeError.invalidDateFormat(string: string, format: dateFormatter.dateFormat)
        }
        
        self.date = parsedDate
    }
    
    /// Init from a string and format.  Will create and cache an appropriate date formatter.
    ///
    /// - parameter string: Date to parse in string format.
    /// - parameter format: Format of the date string.
    /// - parameter calendar: Calendar to assign to the parsed date.  Defaults to the current calendar.
    ///
    /// - throws: DateTimeError.InvalidDateFormat if a date cannot be parsed with the provided format.
    public init(string: String, format: String, calendar: Calendar = Calendar.current) throws {
        
        self.calendar = calendar
        
        let formatterParameters = GearDateFormatterParameters(format: format)
        let formatter = GearDateFormatterCache.dateFormatterFor(formatterParameters)
        
        if let parsedDate = formatter.date(from: string) {
            
            self.date = parsedDate
        
        } else {
            
            throw GearDateTimeError.invalidDateFormat(string: string, format: format)
        }
    }
}

extension GearDateTime {
    
    //
    // MARK: Nested types and Constants
    //
    
    /// Common Formats for dates
    public enum CommonFormats: String {
        
        /// Timestamp based on ISO 8601.  Preferably use with the UTC timezone.
        case iso8601Timestamp = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        /// Little Endian date as defined by ISO 8601
        case ios8601Date = "yyyy-MM-dd"
    }

    /// Default locale.  It is set to en_US_POSIX with respect to the following article:
    /// https://developer.apple.com/library/mac/qa/qa1480/_index.html
    static var defaultLocale: Locale {
        return Locale(identifier: "en_US_POSIX")
    }
    
    /// Gregorian calendar
    static var gregorianCalendar: Calendar {
        return Calendar(identifier: Calendar.Identifier.gregorian)
    }
}

extension GearDateTime {
    
    //
    // MARK: Computed properties
    //

    /// Year
    public var year: Int {
        
        get {
            
            return calendar.component(.year, from: date)
        }
        
        set {
            
            do {
                date = try dateBySettingCalendarUnit(.year, value: newValue)
            
            } catch let error as GearDateTimeError {
                
                debugPrint(error)
                
            } catch {
                
                debugPrint("Unknown exception when setting YEAR:\(newValue)")
            }
        }
    }

    /// Month
    public var month: Int {
        
        get {
            
            return calendar.component(.month, from: date)
        }
        
        set {
            
            do {
                date = try dateBySettingCalendarUnit(.month, value: newValue)
                
            } catch let error as GearDateTimeError {
                
                debugPrint(error)
                
            } catch {
                
                debugPrint("Unknown exception when setting MONTH:\(newValue)")
            }
        }
    }

    /// Day
    public var day: Int {
        
        get {
            
            return calendar.component(.day, from: date)
        }
        
        set {
            
            do {
                date = try dateBySettingCalendarUnit(.day, value: newValue)
                
            } catch let error as GearDateTimeError {
                
                debugPrint(error)
                
            } catch {
                
                debugPrint("Unknown exception when setting DAY:\(newValue)")
            }
        }
    }
    
    /// Hour
    public var hour: Int {
        
        get {
            
            return calendar.component(.hour, from: date)
        }
        
        set {
            
            do {
                date = try dateBySettingCalendarUnit(.hour, value: newValue)
                
            } catch let error as GearDateTimeError {
                
                debugPrint(error)
                
            } catch {
                
                debugPrint("Unknown exception when setting HOUR:\(newValue)")
            }
        }
    }
    
    /// Minute
    public var minute: Int {
        
        get {
            
            return calendar.component(.minute, from: date)
        }
        
        set {
            
            do {
                date = try dateBySettingCalendarUnit(.minute, value: newValue)
                
            } catch let error as GearDateTimeError {
                
                debugPrint(error)
                
            } catch {
                
                debugPrint("Unknown exception when setting MINUTE:\(newValue)")
            }
        }
    }

    /// Seconds
    public var seconds: Int {
        
        get {
            
            return calendar.component(.second, from: date)
        }
        
        set {
            
            do {
                date = try dateBySettingCalendarUnit(.second, value: newValue)
                
            } catch let error as GearDateTimeError {
                
                debugPrint(error)
                
            } catch {
                
                debugPrint("Unknown exception when setting SECOND:\(newValue)")
            }
        }
    }
    
    /// Day of week.  For the gregorian calendar, Sunday = 1 and Saturday = 7.
    public var dayOfWeek: Int {
        
        get {
            
            return calendar.component(.weekday, from: date)
        }
        
        set {
            
            do {
                date = try dateBySettingCalendarUnit(.weekday, value: newValue)
                
            } catch let error as GearDateTimeError {
                
                debugPrint(error)
                
            } catch {
                
                debugPrint("Unknown exception when setting WEEKDAY:\(newValue)")
            }
        }
    }
    
    /// Day of week.  For the gregorian calendar, Sunday = 1 and Saturday = 7.
    public var timeZone: TimeZone {
        
        get {
            
            return calendar.timeZone
        }
        
        set {

            calendar.timeZone = newValue
        }
    }
    
    /// Extract the components from the current date and calendar.
    public var components: DateComponents {
        get {
            
            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .weekday, .timeZone], from: date)
            
            components.calendar = calendar
            
            return components
        }
    }
}

extension GearDateTime {

    //
    // MARK: Computed properties
    //

    /// Get the date time for the first day of a given year/month.
    ///
    /// - parameter year: Year for the month.
    /// - parameter month: Month for which to get the first day.
    /// - parameter calendar: Calendar used to compute the first day.
    ///
    /// - throws A DateTimeError if the year/month is not valid for the given calendar.
    public static func dateForFirstDayOfYearMonth(year: Int, month: Int, calendar: Calendar = Calendar.current) throws -> GearDateTime {

        var components = DateComponents()
        components.calendar = calendar

        components.year = year
        components.month = month
        components.day = 1
        
        return try GearDateTime(components: components)
    }
   
    /// Get the date time for the last day of a given year/month.
    ///
    /// - parameter year: Year for the month.
    /// - parameter month: Month for which to get the last day.
    /// - parameter calendar: Calendar used to compute the last day.
    ///
    /// - throws: A DateTimeError if the year/month is not valid for the given calendar.
    public static func dateForLastDayOfYearMonth(year: Int, month: Int, calendar: Calendar = Calendar.current) throws -> GearDateTime {
        
        var components = DateComponents()
        components.calendar = calendar

        components.year = year
        components.month = month + 1
        components.day = 0

        return try GearDateTime(components: components)
    }

    /// Get an array containing all days for a given year/month.
    ///
    /// - parameter year: Year for the month.
    /// - parameter month: Month for which to get all days.
    /// - parameter calendar: Calendar used to compute days array.
    ///
    /// - throws A DateTimeError if the year/month is not valid for the given calendar.
    public static func allDaysFor(year: Int, month: Int, calendar: Calendar = Calendar.current) throws -> [GearDateTime] {
        
        var returnArray: [GearDateTime] = []
        
        do {
            
            let firstDay = try GearDateTime.dateForFirstDayOfYearMonth(year: year, month: month)
            let lastDay = try GearDateTime.dateForLastDayOfYearMonth(year: year, month: month)
            
            for day in firstDay.day...lastDay.day {
                
                var components = DateComponents()
                components.calendar = calendar
                
                components.year = year
                components.month = month
                components.day = day
                
                returnArray.append(try GearDateTime(components: components))
            }
        
        } catch GearDateTimeError.invalidDateComponents(let year, let month, _) {
            
            throw GearDateTimeError.invalidComponentsForDateArray(year: year, month: month)
        }
        
        return returnArray
    }
    
    /// Get an array containing all days for a given year/month in the gregorian calendar.  
    /// This function is used to display a calendar on screen. Therefore, if the first day of the month is not
    /// a Sunday, it will get days from the previous month until it reaches Sunday.  Likewise, if the last day
    /// of the month is not a Saturday, it will get all days from the next month until it reaches Saturday.
    ///
    /// - parameter year: Year for the month.
    /// - parameter month: Month for which to get all days.
    /// - parameter calendar: Calendar used to compute days array.
    ///
    /// - throws A DateTimeError if the year/month is not valid for the given calendar.
    public static func allDaysWithCompleteWeeksFor(year: Int, month: Int) throws -> [GearDateTime] {
        
        do {
        
            var returnArray: [GearDateTime] = []
            
            let calendar = GearDateTime.gregorianCalendar

            let firstDayOfMonth = try GearDateTime.dateForFirstDayOfYearMonth(year: year, month: month, calendar: calendar)
            let lastDayOfMonth = try GearDateTime.dateForLastDayOfYearMonth(year: year, month: month, calendar: calendar)
            
            // If the first day of the month is not a sunday, we must add days from the previous month
            // until we reach sunday.
            for i in (1..<firstDayOfMonth.dayOfWeek).reversed() {
                
                var dayToAppend = firstDayOfMonth
                dayToAppend.day -= i
                
                returnArray.append(dayToAppend)
            }
            
            // Add all the regular days in the month.
            for day in firstDayOfMonth.day...lastDayOfMonth.day {
                
                var components = DateComponents()
                components.calendar = calendar
                
                components.year = year
                components.month = month
                components.day = day
                
                returnArray.append(try GearDateTime(components: components))
            }
            
            // If the last day of the month is not a saturday, we must add days until we reach saturday
            for (index, _) in (lastDayOfMonth.dayOfWeek ..< 7).enumerated() {
                
                var dayToAppend = lastDayOfMonth
                dayToAppend.day += (index + 1)
                
                returnArray.append(dayToAppend)
            }
            
            return returnArray

        } catch GearDateTimeError.invalidDateComponents(let year, let month, _) {
            
            throw GearDateTimeError.invalidComponentsForDateArray(year: year, month: month)
        }
    }
}

extension GearDateTime {
    
    /// The Calendar date(byAdding:) can only return a date after the current date.
    /// We need to be able to set units for a previous day too.
    ///
    /// - parameter unit: The unit for which to set a new value.
    /// - parameter value: The value of the new unit to set.
    ///
    /// - throws: Exception if the resulting date is invalid.
    ///
    /// - returns: Date constructed with the provided components.
    fileprivate func dateBySettingCalendarUnit(_ unit: Calendar.Component, value: Int) throws -> Date {
        
        var componentsToAdd = DateComponents()
        componentsToAdd.setValue(value - calendar.component(unit, from: date), for: unit)
        
        guard let returnDate = calendar.date(byAdding: componentsToAdd, to: date, wrappingComponents: false) else {
         
            let componentsForCurrentDate = calendar.dateComponents([.year, .month, .day], from: date)
            
            let componentYear = componentsForCurrentDate.year == nil || componentsToAdd.year == nil
                ? nil
                : componentsForCurrentDate.year! + componentsToAdd.year!
            
            let componentMonth = componentsForCurrentDate.month == nil || componentsToAdd.month == nil
                ? nil
                : componentsForCurrentDate.month! + componentsToAdd.month!
            
            let componentDay = componentsForCurrentDate.day == nil || componentsToAdd.day == nil
                ? nil
                : componentsForCurrentDate.day! + componentsToAdd.day!

            throw GearDateTimeError.invalidDateComponents(year: componentYear
                , month: componentMonth
                , day: componentDay)
        }
        
        return returnDate
    }
}

/// Print the description of a DateTime
extension GearDateTime :  CustomStringConvertible {
    
    /// Exception description.
    public var description: String {

        let parameters = GearDateFormatterParameters(format: CommonFormats.iso8601Timestamp.rawValue
            , timezone: TimeZone(abbreviation: "UTC")!
            , locale: GearDateTime.defaultLocale
            , calendar: self.calendar)
        
        let dateFormatter = GearDateFormatterCache.dateFormatterFor(parameters)
        
        return dateFormatter.string(from: self.date)
    }
}

/// Print the debug description of a DateTime
extension GearDateTime :  CustomDebugStringConvertible {
    
    /// Exception description.
    public var debugDescription: String {
        
        let parameters = GearDateFormatterParameters(format: CommonFormats.iso8601Timestamp.rawValue
            , timezone: TimeZone(abbreviation: "UTC")!
            , locale: GearDateTime.defaultLocale
            , calendar: self.calendar)
        
        let dateFormatter = GearDateFormatterCache.dateFormatterFor(parameters)
        
        return dateFormatter.string(from: self.date)
    }
}

public extension GearDateTime {
    
    public func stringForFormat(_ format: String) -> String {
        
        let parameters = GearDateFormatterParameters(format: format
            , timezone: TimeZone(abbreviation: "UTC")!
            , locale: GearDateTime.defaultLocale
            , calendar: self.calendar)

        let dateFormatter = GearDateFormatterCache.dateFormatterFor(parameters)
        
        return dateFormatter.string(from: self.date)
    }
    
    public func stringForFormatCurrentTimezone(_ format: String) -> String {
        
        let parameters = GearDateFormatterParameters(format: format
            , timezone: TimeZone.autoupdatingCurrent
            , locale: GearDateTime.defaultLocale
            , calendar: self.calendar)
        
        let dateFormatter = GearDateFormatterCache.dateFormatterFor(parameters)
        return dateFormatter.string(from: self.date)
    }

}

