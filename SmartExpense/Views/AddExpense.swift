//
//  AddExpense.swift
//  SmartExpense
//
//  Created by Saranya JayaKumar on 12/08/26.
//

import SwiftUI

struct AddExpense: View {
    @Environment(\.dismiss) private var dismiss
    var viewModel: ExpenseViewModel

    @State private var title = ""
    @State private var amount = ""
    @State private var category = "Food"
    @State private var isIncome = false
    @State private var date = Date()

    let categories = ["Food", "Shopping", "Bills", "Travel", "Salary", "Other"]

    var body: some View {
        NavigationStack {
            Form {
                Picker("Type", selection: $isIncome) {
                    Text("Expense").tag(false)
                    Text("Income").tag(true)
                }
                .pickerStyle(.segmented)

                TextField("Title", text: $title)
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)

                Picker("Category", selection: $category) {
                    ForEach(categories, id: \.self) { cat in
                        Text(cat)
                    }
                }

                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            .navigationTitle(isIncome ? "Add Income" : "Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.addExpense(title: title, amount: amount, category: category, isIncome: isIncome, date: date)
                        dismiss()
                    }
                }
            }
        }
    }
}
