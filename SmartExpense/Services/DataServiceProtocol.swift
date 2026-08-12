//
//  DataServiceProtocol.swift
//  SmartExpense
//
//  Created by Saranya JayaKumar on 12/08/26.
//

import Foundation

protocol DataServiceProtocol {
    func fetchExpenses() throws  -> [ExpenseItem]
    func addeExpense(_ item: ExpenseItem) throws
    func deleteExpense(_ item: ExpenseItem) throws
}
