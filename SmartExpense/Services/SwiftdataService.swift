//
//  SwiftdataService.swift
//  SmartExpense
//
//  Created by Saranya JayaKumar on 12/08/26.
//

import Foundation
import SwiftData

final class SwiftdataService: DataServiceProtocol {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    func fetchExpenses() throws -> [ExpenseItem] {
        let descriptor = FetchDescriptor<ExpenseItem>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return try modelContext.fetch(descriptor)
        
    }
    func addeExpense(_ item: ExpenseItem) throws {
        modelContext.insert(item)
        try modelContext.save()
    }
    func deleteExpense(_ item: ExpenseItem) throws {
        modelContext.delete(item)
        try modelContext.save()
    }
    
}
