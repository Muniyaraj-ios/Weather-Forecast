//
//  Extensions.swift
//  Weather Forecast App
//
//  Created by Apple on 14/01/24.
//

import Foundation

extension Date{
    func currentFormattedDate(with format: DateFormats = .dateFullForm) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.format
         //"E, MMM d, yyyy"
         //"E, MMMM d, yyyy"
         //"EEEE, MMMM d, yyyy"
        return dateFormatter.string(from: Date())
    }
    func dateFormattedString(i ind: Int) -> String {
        let date = Calendar.current.date(byAdding: .day, value: ind, to: Date()) ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d"
        return dateFormatter.string(from: date)
    }
}

extension Double{
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
    func addZerosFromEnd(max: Int = 2) -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = max
        formatter.maximumFractionDigits = max //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
    func roundToDecimal(_ fractionDigits:Int = 1) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
    func meterToKiloMeter() -> Double {
        return (self / 1000).roundToDecimal(1)
    }
}
extension String{
    func formatDate(with form: DateFormats) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.baseFormat.format

        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = form.format
            return dateFormatter.string(from: date)
        } else {
            return "Invalid Date"
        }
    }
    func formatDateString(currentForm dateFormat: DateFormats,newForm newdateFormat: DateFormats) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.format

        let date = dateFormatter.date(from: self) ?? Date()
        dateFormatter.dateFormat = newdateFormat.format
        return dateFormatter.string(from: date)
    }
}
enum DateFormats{
    case baseFormat
    case dayDateWeek
    case dayDate
    case dayDateWeekyear
    case dateMonYear
    case dateFullForm
    case time
    var format: String{
        switch self{
        case .baseFormat: return "yyyy-MM-dd HH:mm:ss"
        case .dayDateWeek: return "E, d MMM"
        case .dayDate: return "E, d"
        case .dayDateWeekyear: return "E, d MMM yyyy"
        case .dateMonYear: return "dd/MM/yyyy"
        case .dateFullForm: return "EEEE, MMMM d, yyyy"
        case .time: return "h:mm a"
        }
    }
}

 //"E, MMM d, yyyy"
 //"E, MMMM d, yyyy"
 //"EEEE, MMMM d, yyyy"
