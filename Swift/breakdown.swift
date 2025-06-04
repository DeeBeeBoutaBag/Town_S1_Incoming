import Foundation

// MARK: - Calculator State Structure
struct CalculatorState {
    let currentValue: Double
    let previousValue: Double
    let operation: String
    
    init(currentValue: Double, previousValue: Double, operation: String) {
        self.currentValue = currentValue
        self.previousValue = previousValue
        self.operation = operation
    }
}

// MARK: - Main Calculator Class
class Calculator {
    
    // MARK: - Core Properties
    private(set) var currentValue: Double = 0
    private var previousValue: Double = 0
    private var operation: String = ""
    private var displayString: String = "0"
    private var enteringNumber: Bool = false
    private var shouldResetDisplay: Bool = false
    
    // MARK: - Memory Properties
    private var memory: Double = 0
    private var hasMemoryValue: Bool = false
    
    // MARK: - History Properties
    private var history: [CalculatorState] = []
    private var historyIndex: Int = -1
    private let maxHistorySize = 20
    
    // MARK: - Initialization
    init() {
        saveCurrentState()
    }
    
    // MARK: - Main Interface
    func run() {
        print("🧮 Swift Calculator")
        print("Type 'help' for commands or 'quit' to exit")
        
        while true {
            displayCurrentState()
            print("Enter command: ", terminator: "")
            
            guard let input = readLine()?.trimmingCharacters(in: .whitespaces) else {
                continue
            }
            
            if input.lowercased() == "quit" {
                print("Goodbye! 👋")
                break
            }
            
            processInput(input)
        }
    }
    
    // MARK: - Input Processing
    func processInput(_ input: String) {
        let lowercasedInput = input.lowercased()
        
        // Handle special commands
        if handleSpecialCommands(lowercasedInput) {
            return
        }
        
        // Handle memory commands
        if handleMemoryCommands(lowercasedInput) {
            return
        }
        
        // Handle number input
        if let number = Double(input) {
            inputNumber(number)
            return
        }
        
        // Handle basic operations
        if isValidBasicOperation(input) {
            setOperation(input)
            return
        }
        
        // Handle other commands
        switch lowercasedInput {
        case "=", "enter":
            calculate()
        case ".", "decimal":
            inputDecimal()
        case "+/-", "sign":
            toggleSign()
        case "%", "percent":
            percentage()
        case "clear", "c":
            clearEntry()
        case "ac", "allclear":
            clearAll()
        default:
            print("❌ Invalid input: '\(input)'. Type 'help' for available commands.")
        }
        
        saveCurrentState()
    }
    
    // MARK: - Special Commands
    func handleSpecialCommands(_ input: String) -> Bool {
        switch input {
        case "help":
            showHelp()
            return true
        case "history":
            showHistory()
            return true
        case "undo":
            _ = undo()
            return true
        case "redo":
            _ = redo()
            return true
        case "status":
            showStatus()
            return true
        default:
            return false
        }
    }
    
    // MARK: - Number Input
    func inputNumber(_ number: Double) {
        if shouldResetDisplay || !enteringNumber {
            currentValue = number
            displayString = formatNumber(number)
            enteringNumber = true
            shouldResetDisplay = false
        } else {
            let currentString = String(Int(number))
            if displayString == "0" {
                displayString = currentString
            } else if displayString.count < 10 {
                displayString += currentString
            }
            currentValue = Double(displayString) ?? currentValue
        }
    }
    
    func inputDecimal() {
        if shouldResetDisplay || !enteringNumber {
            displayString = "0."
            enteringNumber = true
            shouldResetDisplay = false
        } else if !displayString.contains(".") && displayString.count < 9 {
            displayString += "."
        }
        currentValue = Double(displayString) ?? currentValue
    }
    
    // MARK: - Basic Operations
    func isValidBasicOperation(_ op: String) -> Bool {
        return ["+", "-", "*", "/", "×", "÷"].contains(op)
    }
    
    func setOperation(_ op: String) {
        let normalizedOp = normalizeOperation(op)
        
        if !operation.isEmpty && enteringNumber {
            calculate()
        }
        
        operation = normalizedOp
        previousValue = currentValue
        shouldResetDisplay = true
        enteringNumber = false
        
        print("🔢 Operation set: \(normalizedOp)")
    }
    
    func normalizeOperation(_ op: String) -> String {
        switch op {
        case "×": return "*"
        case "÷": return "/"
        default: return op
        }
    }
    
    func calculate() {
        guard !operation.isEmpty else {
            print("❌ No operation to perform")
            return
        }
        
        let result = performOperation(operation, previous: previousValue, current: currentValue)
        currentValue = result
        displayString = formatNumber(result)
        operation = ""
        previousValue = 0
        shouldResetDisplay = true
        enteringNumber = false
        
        print("✅ Result: \(formatNumber(currentValue))")
    }
    
    func performOperation(_ op: String, previous: Double, current: Double) -> Double {
        switch op {
        case "+":
            return previous + current
        case "-":
            return previous - current
        case "*":
            return previous * current
        case "/":
            if current != 0 {
                return previous / current
            } else {
                print("❌ Error: Division by zero")
                return previous
            }
        default:
            print("❌ Unknown operation: \(op)")
            return current
        }
    }
    
    // MARK: - Special Functions
    func toggleSign() {
        currentValue = -currentValue
        displayString = formatNumber(currentValue)
        print("🔄 Sign toggled: \(formatNumber(currentValue))")
    }
    
    func percentage() {
        currentValue = currentValue / 100
        displayString = formatNumber(currentValue)
        print("📊 Percentage: \(formatNumber(currentValue))")
    }
    
    func clearEntry() {
        currentValue = 0
        displayString = "0"
        enteringNumber = false
        shouldResetDisplay = false
        print("🧹 Entry cleared")
    }
    
    func clearAll() {
        currentValue = 0
        previousValue = 0
        operation = ""
        displayString = "0"
        enteringNumber = false
        shouldResetDisplay = false
        print("🧹 All cleared")
    }
    
    // MARK: - Memory Functions
    func handleMemoryCommands(_ input: String) -> Bool {
        switch input {
        case "ms", "mstore":
            memoryStore()
            return true
        case "mr", "mrecall":
            memoryRecall()
            return true
        case "m+", "madd":
            memoryAdd()
            return true
        case "m-", "msub":
            memorySubtract()
            return true
        case "mc", "mclear":
            memoryClear()
            return true
        default:
            return false
        }
    }
    
    func memoryStore() {
        memory = currentValue
        hasMemoryValue = true
        print("💾 Memory stored: \(formatNumber(memory))")
    }
    
    func memoryRecall() {
        if hasMemoryValue {
            currentValue = memory
            displayString = formatNumber(memory)
            shouldResetDisplay = true
            enteringNumber = false
            print("📤 Memory recalled: \(formatNumber(memory))")
        } else {
            print("❌ No value in memory")
        }
    }
    
    func memoryAdd() {
        memory += currentValue
        hasMemoryValue = true
        print("➕ Added to memory. New value: \(formatNumber(memory))")
    }
    
    func memorySubtract() {
        memory -= currentValue
        hasMemoryValue = true
        print("➖ Subtracted from memory. New value: \(formatNumber(memory))")
    }
    
    func memoryClear() {
        memory = 0
        hasMemoryValue = false
        print("🗑️ Memory cleared")
    }
    
    // MARK: - History Management
    func saveCurrentState() {
        let state = CalculatorState(
            currentValue: currentValue,
            previousValue: previousValue,
            operation: operation
        )
        
        if historyIndex < history.count - 1 {
            history.removeSubrange((historyIndex + 1)...)
        }
        
        history.append(state)
        historyIndex = history.count - 1
        
        if history.count > maxHistorySize {
            history.removeFirst()
            historyIndex -= 1
        }
    }
    
    func undo() -> Bool {
        guard historyIndex > 0 else {
            print("❌ Cannot undo further")
            return false
        }
        
        historyIndex -= 1
        let state = history[historyIndex]
        restoreState(state)
        print("↶ Undone to: \(formatNumber(currentValue))")
        return true
    }
    
    func redo() -> Bool {
        guard historyIndex < history.count - 1 else {
            print("❌ Cannot redo further")
            return false
        }
        
        historyIndex += 1
        let state = history[historyIndex]
        restoreState(state)
        print("↷ Redone to: \(formatNumber(currentValue))")
        return true
    }
    
    private func restoreState(_ state: CalculatorState) {
        currentValue = state.currentValue
        previousValue = state.previousValue
        operation = state.operation
        displayString = formatNumber(currentValue)
        shouldResetDisplay = true
        enteringNumber = false
    }
    
    func showHistory() {
        print("\n📜 Calculation History:")
        if history.isEmpty {
            print("   No history available")
            return
        }
        
        let startIndex = max(0, history.count - 10)
        for index in startIndex..<history.count {
            let state = history[index]
            let marker = index == historyIndex ? "→ " : "  "
            print("\(marker)\(formatNumber(state.currentValue))")
        }
        print()
    }
    
    // MARK: - Display and Formatting
    func formatNumber(_ number: Double) -> String {
        if number.isInfinite {
            return number > 0 ? "∞" : "-∞"
        }
        if number.isNaN {
            return "Error"
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 8
        formatter.minimumFractionDigits = 0
        
        if abs(number) >= 1e8 || (abs(number) < 1e-4 && number != 0) {
            formatter.numberStyle = .scientific
            formatter.maximumFractionDigits = 3
        }
        
        return formatter.string(from: NSNumber(value: number)) ?? "0"
    }
    
    func displayCurrentState() {
        var statusLine = "📟 \(formatNumber(currentValue))"
        
        if !operation.isEmpty {
            statusLine += " \(operation)"
        }
        
        if hasMemoryValue {
            statusLine += " [M: \(formatNumber(memory))]"
        }
        
        print("\n\(statusLine)")
    }
    
    func showStatus() {
        print("\n📊 Calculator Status:")
        print("   Current Value: \(formatNumber(currentValue))")
        print("   Previous Value: \(formatNumber(previousValue))")
        print("   Operation: \(operation.isEmpty ? "None" : operation)")
        print("   Memory: \(hasMemoryValue ? formatNumber(memory) : "Empty")")
        print("   History Entries: \(history.count)")
        print()
    }
    
    // MARK: - Help System
    func showHelp() {
        print("""
        
        🧮 Swift Calculator Help
        ========================
        
        📱 Basic Operations:
        • Numbers: Enter any number (e.g., 123, 45.67)
        • +, -, *, /: Basic arithmetic operations
        • = or enter: Calculate result
        • clear or c: Clear current entry
        • ac or allclear: Clear everything
        
        🧠 Memory Operations:
        • ms or mstore: Memory store
        • mr or mrecall: Memory recall
        • m+ or madd: Add to memory
        • m- or msub: Subtract from memory
        • mc or mclear: Memory clear
        
        🔧 Special Functions:
        • %: Convert to percentage
        • +/- or sign: Toggle positive/negative
        • . or decimal: Add decimal point
        
        ⚙️ Navigation:
        • undo: Undo last operation
        • redo: Redo last undone operation
        • history: Show calculation history
        • status: Show detailed calculator status
        
        ❓ Other Commands:
        • help: Show this help message
        • quit: Exit calculator
        
        💡 Examples:
        • 5 + 3 = → Result: 8
        • 10 / 2 = → Result: 5
        • 50 % → Result: 0.5 (50%)
        • 7 +/- → Result: -7
        
        """)
    }
}



// MARK: - Main Entry Point
let calculator = Calculator()
calculator.run()

