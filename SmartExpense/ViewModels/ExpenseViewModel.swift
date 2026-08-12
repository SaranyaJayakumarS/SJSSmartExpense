//
//  ExpenseViewModel.swift
//  SmartExpense
//
//  Created by Saranya JayaKumar on 12/08/26.
//

import Foundation
import SwiftData
import Observation

@Observable
final class ExpenseViewModel {
    var expenses: [ExpenseItem] = []
    private var dataService: DataServiceProtocol?

    func setupService(modelContext: ModelContext) {
        self.dataService = SwiftdataService(modelContext: modelContext)
        fetchData()
    }

    func fetchData() {
        do {
            expenses = try dataService?.fetchExpenses() ?? []
        } catch {
            print("Error fetching expenses: \(error)")
        }
    }

    func addExpense(title: String, amount: String, category: String, isIncome: Bool, date: Date) {
        guard let doubleAmount = Double(amount), !title.isEmpty else { return }
        let newItem = ExpenseItem(title: title, amount: doubleAmount, date: date, category: category, isIncome: isIncome)
        
        do {
            try dataService?.addeExpense(newItem)
            fetchData()
        } catch {
            print("Error adding item: \(error)")
        }
    }

    func deleteExpense(_ item: ExpenseItem) {
        do {
            try dataService?.deleteExpense(item)
            fetchData()
        } catch {
            print("Error deleting item: \(error)")
        }
    }

    // Dynamic Calculations for UI
    var totalIncome: Double {
        expenses.filter { $0.isIncome }.reduce(0) { $0 + $1.amount }
    }

    var totalExpense: Double {
        expenses.filter { !$0.isIncome }.reduce(0) { $0 + $1.amount }
    }

    var balance: Double {
        totalIncome - totalExpense
    }
}
