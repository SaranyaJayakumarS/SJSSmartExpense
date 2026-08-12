//
//  ExpenseListView.swift
//  SmartExpense
//
//  Created by Saranya JayaKumar on 12/08/26.
//

import SwiftUI

struct ExpenseListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ExpenseViewModel()
    @State private var showAddExpense = false

    var body: some View {
        NavigationStack {
            List {
                // Total Summary Card Section
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Total Balance")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("$\(viewModel.balance, specifier: "%.2f")")
                            .font(.title)
                            .bold()

                        HStack {
                            VStack(alignment: .leading) {
                                Text("Income").font(.caption).foregroundStyle(.secondary)
                                Text("$\(viewModel.totalIncome, specifier: "%.2f")")
                                    .bold().foregroundColor(.green)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("Expense").font(.caption).foregroundStyle(.secondary)
                                Text("$\(viewModel.totalExpense, specifier: "%.2f")")
                                    .bold().foregroundColor(.red)
                            }
                        }
                    }
                    .padding(.vertical, 5)
                }

                // Recent Transactions Section
                Section("Transactions") {
                    ForEach(viewModel.expenses) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.title).font(.headline)
                                Text(item.category).font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("$\(item.amount, specifier: "%.2f")")
                                .bold()
                                .foregroundColor(item.isIncome ? .green : .primary)
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            viewModel.deleteExpense(viewModel.expenses[index])
                        }
                    }
                }
            }
            .navigationTitle("Smart Expense")
            .toolbar {
                Button {
                    showAddExpense = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                }
            }
            .sheet(isPresented: $showAddExpense) {
                AddExpense(viewModel: viewModel)
            }
            .onAppear {
                viewModel.setupService(modelContext: modelContext)
            }
        }
    }
}
