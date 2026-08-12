//
//  ExpenseItem.swift
//  SmartExpense
//
//  Created by Saranya JayaKumar on 12/08/26.
//

import Foundation
import SwiftData

@Model
final class ExpenseItem {
    @Attribute(.unique)
    var id : UUID
    var title : String
    var amount : Double
    var date : Date
    var category : String
    var isIncome : Bool
    init(title: String, amount: Double, date: Date = Date(), category: String, isIncome: Bool = false) {
        self.id = UUID()
        self.title = title
        self.amount = amount
        self.date = date
        self.category = category
        self.isIncome = isIncome
    }
    
}
