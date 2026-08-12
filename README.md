Project Folder & Layer Structure
Organize your Xcode project into logical group folders to maintain clean code separation:
SmartExpense/
├── Models/
│ └── ExpenseItem.swift
├── Services/
│ ├── DataServiceProtocol.swift
│ └── SwiftDataService.swift
├── ViewModels/
│ └── ExpenseViewModel.swift
├── Views/
│ ├── ExpenseListView.swift
│ ├── AddExpenseView.swift
│ └── ExpenseChartView.swift
└── Utilities/
└── Extensions.swift
2. Model Definition (SwiftData)
Using iOS 17's native @Model macro for seamless persistent storage.
import Foundation
import SwiftData
@Model
final class ExpenseItem {
@Attribute(.unique) var id: UUID
var title: String
var amount: Double
var category: String
var date: Date
init(id: UUID = UUID(), title: String, amount: Double, category: String, date: Date =
Date()) {
self.id = id
self.title = title
self.amount = amount
self.category = category
self.date = date
}
}
3. Dependency Injection & Service Layer
Protocol-driven design ensures decoupled code that is easily testable via Mock Services.
import Foundation
import SwiftData
// Protocol abstraction for Dependency Injection
protocol DataServiceProtocol {
func fetchExpenses() throws -> [ExpenseItem]
func addExpense(_ item: ExpenseItem) throws
func deleteExpense(_ item: ExpenseItem) throws
}
final class SwiftDataService: DataServiceProtocol {
private let modelContainer: ModelContainer
private let modelContext: ModelContext
@MainActor
init(inMemory: Bool = false) {
do {
let config = ModelConfiguration(isStoredInMemoryOnly: inMemory)
self.modelContainer = try ModelContainer(for: ExpenseItem.self, configurations:
config)
self.modelContext = modelContainer.mainContext
} catch {
(error.localizedDescription)")
fatalError("Failed to initialize SwiftData ModelContainer: \
}
}
func fetchExpenses() throws -> [ExpenseItem] {
let descriptor = FetchDescriptor(sortBy: [SortDescriptor(\.date, order: .reverse)])
return try modelContext.fetch(descriptor)
}
func addExpense(_ item: ExpenseItem) throws {
modelContext.insert(item)
try modelContext.save()
}
func deleteExpense(_ item: ExpenseItem) throws {
modelContext.delete(item)
try modelContext.save()
}
}
4. ViewModel Implementation (MVVM)
The ViewModel handles business logic and communicates with the service layer via injected dependencies.
import Foundation
import Combine
@MainActor
final class ExpenseViewModel: ObservableObject {
@Published private(set) var expenses: [ExpenseItem] = []
@Published var errorMessage: String? = nil
private let dataService: DataServiceProtocol
// Dependency Injection via Initializer
init(dataService: DataServiceProtocol) {
self.dataService = dataService
loadExpenses()
}
func loadExpenses() {
do {
self.expenses = try dataService.fetchExpenses()
} catch {
self.errorMessage = "Failed to load expenses: \(error.localizedDescription)"
}
}
func addExpense(title: String, amount: Double, category: String) {
guard !title.isEmpty, amount > 0 else { return }
let newItem = ExpenseItem(title: title, amount: amount, category: category)
do {
try dataService.addExpense(newItem)
loadExpenses()
} catch {
self.errorMessage = "Failed to add expense."
}
}
func deleteExpense(at offsets: IndexSet) {
for index in offsets {
let item = expenses[index]
do {
try dataService.deleteExpense(item)
} catch {
self.errorMessage = "Failed to delete expense."
}
}
loadExpenses()
var totalExpense: Double {
expenses.reduce(0) { $1.amount }
}
}
}
5. User Interface (SwiftUI Views)
Clean, interactive SwiftUI views utilizing modern NavigationStack and Swift Charts.
import SwiftUI
import Charts
struct ExpenseListView: View {
@StateObject private var viewModel: ExpenseViewModel
@State private var showingAddExpense = false
init(dataService: DataServiceProtocol) {
_viewModel = StateObject(wrappedValue: ExpenseViewModel(dataService: dataService))
}
var body: some View {
NavigationStack {
List {
Section("Summary") {
HStack {
Text("Total Spent")
.font(.headline)
Spacer()
Text("$\(viewModel.totalExpense, specifier: "%.2f")")
.font(.title2)
.bold()
.foregroundColor(.blue)
}
}
Section("Recent Expenses") {
ForEach(viewModel.expenses) { item in
HStack {
VStack(alignment: .leading, spacing: 4) {
Text(item.title)
.font(.body)
.bold()
Text(item.category)
.font(.caption)
.foregroundColor(.secondary)
}
Spacer()
Text("$\(item.amount, specifier: "%.2f")")
.fontWeight(.semibold)
}
}
.onDelete(perform: viewModel.deleteExpense)
}
}
.navigationTitle("Expenses")
.toolbar {
Button(action: { showingAddExpense = true }) {
Image(systemName: "plus.circle.fill")
.font(.title3)
}
}
.sheet(isPresented: $showingAddExpense) {
AddExpenseView(viewModel: viewModel)
}
}
}
}

