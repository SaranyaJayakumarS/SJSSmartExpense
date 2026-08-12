//
//  SmartExpenseApp.swift
//  SmartExpense
//
//  Created by Saranya JayaKumar on 12/08/26.
//

import SwiftUI
import SwiftData

@main
struct SmartExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ExpenseItem.self)
    }
}
