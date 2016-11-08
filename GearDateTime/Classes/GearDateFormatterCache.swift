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

// Note: Since iOS7, the DateFormatter object is thread safe.
// However, changing the date format between threads is not safe, so we'll keep an instance for each
// format/timezone combination.
class GearDateFormatterCache {
    
    //
    // MARK: Singleton pattern
    //
    
    /// Singleton instance.
    static let sharedInstance = GearDateFormatterCache()

    /// Private initializer
    fileprivate init() {
        
    }
    
    //
    // MARK: Stored properties
    //

    /// Limit for formatters in the cache.
    fileprivate static let CACHE_ENTRY_LIMIT = 16
    
    /// Dictionary of cached formatters.
    fileprivate var dateFormatterDictionary: [String : DateFormatter] = [:]
}

extension GearDateFormatterCache {
    
    //
    // MARK: Class functions
    //

    /// Add formatter to the cache.
    ///
    /// - parameter formatter Formatter to add to the cache.
    class func addFormatter(_ formatter: DateFormatter) {
        
        if sharedInstance.dateFormatterDictionary.count >= GearDateFormatterCache.CACHE_ENTRY_LIMIT {
            
            sharedInstance.removeRandomFormatterFromCache()
        }
        
        let parameters = GearDateFormatterParameters(format: formatter.dateFormat, timezone: formatter.timeZone, locale: formatter.locale, calendar: formatter.calendar)
        
        sharedInstance.dateFormatterDictionary[parameters.id] = formatter
    }
    
    /// Generate a formatter using the provided parameters.  Add the generated formatter to the cache.
    ///
    /// - parameter format: Format of the dates to parse.
    /// - parameter timezone: Timezone of the formatter.  Defaults to the local timezone.
    /// - parameter locale: Locale of the formatter.  Defaults to POSIX for en_us.
    /// - parameter calendar: Calendar for the formatter.  Defaults to the gregorian calendar.
    class func dateFormatterFor(_ parameters: GearDateFormatterParameters) -> DateFormatter {
        
        if let dateFormatter = sharedInstance.dateFormatterDictionary[parameters.id] {
            
            return dateFormatter
            
        } else {
            
            if sharedInstance.dateFormatterDictionary.count >= GearDateFormatterCache.CACHE_ENTRY_LIMIT {

                sharedInstance.removeRandomFormatterFromCache()
            }

            let newDateFormatter = DateFormatter()
            newDateFormatter.timeZone = parameters.timezone
            newDateFormatter.dateFormat = parameters.format
            
            newDateFormatter.locale = parameters.locale
            newDateFormatter.calendar = parameters.calendar
            
            sharedInstance.dateFormatterDictionary[parameters.id] = newDateFormatter

            return newDateFormatter
        }
    }
}

extension GearDateFormatterCache {
    
    //
    // MARK: Private functions.
    //

    /// Remove a random formatter from the cache to make room for another one to add.
    fileprivate func removeRandomFormatterFromCache() {
        
        // Swift dictionaries are not ordered.  Delete a random element;
        // we will choose the middle one but it is purely a random decision.
        let middleIndexPosition = dateFormatterDictionary.indices.count / 2
        let indexToRemove = dateFormatterDictionary.index(dateFormatterDictionary.startIndex, offsetBy: middleIndexPosition)
        dateFormatterDictionary.remove(at: indexToRemove)
    }
}

struct GearDateFormatterParameters {
    
    //
    // MARK: Stored properties.
    //

    /// Format
    let format: String
    
    /// Timezone
    let timezone: TimeZone
    
    /// Locale
    let locale: Locale
    
    /// Calendar
    let calendar: Calendar
    
    //
    // MARK: Initialization.
    //

    /// Initialize with all the parameters
    ///
    /// - parameter format: Format.  Mandatory parameter.
    /// - parameter timezone: Timezone.  Defaults to local time zone.
    /// - parameter locale: Locale.  Defaults to the en_us_POSIX.  
    /// - parameter calendar: Calendar.  Defaults to the gregorian calendar.
    init(format: String
        , timezone: TimeZone = TimeZone.autoupdatingCurrent
        , locale: Locale = GearDateTime.defaultLocale as Locale
        , calendar: Calendar = GearDateTime.gregorianCalendar as Calendar) {
        
        self.format = format
        self.timezone = timezone
        self.locale = locale
        self.calendar = calendar
    }
    
    //
    // MARK: Computed properties.
    //

    /// Id string associated with the properties.
    var id: String {
        return (format + timezone.identifier + locale.identifier + "\(calendar.identifier)")
    }
}
