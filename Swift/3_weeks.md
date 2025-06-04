# Swift Calculator Course - 12 Lesson Curriculum

## Course Overview
Build a fully functional calculator using pure Swift code. Students will learn Swift fundamentals while creating a practical, command-line calculator that can be extended to other platforms.

**Prerequisites:** Basic computer literacy, Xcode or Swift compiler installed
**Duration:** 12 hours (12 x 1-hour lessons)
**Final Product:** Swift Calculator with basic arithmetic operations

---

## Lesson 1: Swift Basics & Project Setup
**Duration:** 60 minutes

### Learning Objectives
- Understand Swift syntax fundamentals
- Set up Swift project environment
- Create the basic calculator structure

### Topics Covered
- Variables and constants (var, let)
- Basic data types (Int, Double, String, Bool)
- Functions and methods
- Creating Swift files and running code

### Hands-on Activity
- Create new Swift playground or command-line project
- Write first Swift calculator code

```swift
// Basic Swift calculator setup
import Foundation

class Calculator {
    var currentValue: Double = 0
    var previousValue: Double = 0
    var operation: String = ""
    
    func displayValue() -> String {
        return String(currentValue)
    }
    
    func reset() {
        currentValue = 0
        previousValue = 0
        operation = ""
    }
}

// Test the calculator
let calc = Calculator()
print("Calculator initialized: \(calc.displayValue())")
```

### Homework
Practice declaring different variable types and create simple calculator functions

```swift
// Homework practice
var age: Int = 25
let pi: Double = 3.14159
var name: String = "Calculator"
var isActive: Bool = true

func greet(name: String) -> String {
    return "Hello, \(name)!"
}

print(greet(name: "Swift Calculator"))
```

---

## Lesson 2: Functions and Methods
**Duration:** 60 minutes

### Learning Objectives
- Create calculator functions
- Understand parameter passing
- Learn return types and optionals

### Topics Covered
- Function syntax and parameters
- Return types
- Optional values
- Method vs function distinction

### Hands-on Activity
- Create basic arithmetic functions
- Handle input validation

```swift
class Calculator {
    var currentValue: Double = 0
    var previousValue: Double = 0
    var operation: String = ""
    
    func inputNumber(_ number: Double) {
        currentValue = number
    }
    
    func inputDigit(_ digit: String) {
        if let digitValue = Double(digit) {
            let currentString = String(currentValue)
            if currentString == "0" {
                currentValue = digitValue
            } else {
                let newString = currentString + digit
                currentValue = Double(newString) ?? currentValue
            }
        }
    }
    
    func clear() {
        currentValue = 0
        previousValue = 0
        operation = ""
    }
}
```

### Homework
Create additional helper functions for number formatting and validation

---

## Lesson 3: User Input and Control Flow
**Duration:** 60 minutes

### Learning Objectives
- Handle user input from command line
- Implement control flow (if/else, switch)
- Create interactive calculator interface

### Topics Covered
- Reading user input with readLine()
- Conditional statements
- Switch statements
- While loops for continuous operation

### Hands-on Activity
- Create interactive command-line interface
- Implement basic user input handling

```swift
import Foundation

class Calculator {
    var currentValue: Double = 0
    var previousValue: Double = 0
    var operation: String = ""
    
    func run() {
        print("Swift Calculator - Enter 'quit' to exit")
        
        while true {
            print("Current value: \(formatNumber(currentValue))")
            print("Enter number or operation (+, -, *, /, =, clear, quit):")
            
            guard let input = readLine()?.trimmingCharacters(in: .whitespaces) else {
                continue
            }
            
            if input.lowercased() == "quit" {
                break
            }
            
            handleInput(input)
        }
    }
    
    func handleInput(_ input: String) {
        if let number = Double(input) {
            currentValue = number
        } else {
            switch input {
            case "+", "-", "*", "/":
                setOperation(input)
            case "=":
                calculate()
            case "clear":
                clear()
            default:
                print("Invalid input: \(input)")
            }
        }
    }
    
    func formatNumber(_ number: Double) -> String {
        if number == floor(number) {
            return String(Int(number))
        } else {
            return String(number)
        }
    }
}
```

### Homework
Test the interactive interface and add input validation

---

## Lesson 4: Arithmetic Operations Implementation
**Duration:** 60 minutes

### Learning Objectives
- Implement basic math operations
- Handle operation state management
- Create calculation logic

### Topics Covered
- Addition, subtraction, multiplication, division
- State management between operations
- Error handling for invalid operations

### Hands-on Activity
- Implement core arithmetic functions
- Add operation state handling

```swift
extension Calculator {
    func setOperation(_ op: String) {
        if !operation.isEmpty {
            calculate() // Perform pending operation first
        }
        operation = op
        previousValue = currentValue
        print("Operation set: \(op)")
    }
    
    func calculate() {
        guard !operation.isEmpty else {
            print("No operation to perform")
            return
        }
        
        let result = performOperation(operation, previous: previousValue, current: currentValue)
        currentValue = result
        operation = ""
        previousValue = 0
        
        print("Result: \(formatNumber(currentValue))")
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
                print("Error: Division by zero")
                return previous
            }
        default:
            print("Unknown operation: \(op)")
            return current
        }
    }
}
```

### Homework
Test all arithmetic operations and handle edge cases

---

## Lesson 5: Advanced Operations and Error Handling
**Duration:** 60 minutes

### Learning Objectives
- Add percentage and sign operations
- Implement comprehensive error handling
- Create robust calculation logic

### Topics Covered
- Percentage calculations
- Sign toggle functionality
- Error handling patterns in Swift
- Optional chaining and nil coalescing

### Hands-on Activity
- Add percentage and sign toggle features
- Implement error handling

```swift
extension Calculator {
    func percentage() {
        currentValue = currentValue / 100
        print("Percentage: \(formatNumber(currentValue))")
    }
    
    func toggleSign() {
        currentValue = -currentValue
        print("Sign toggled: \(formatNumber(currentValue))")
    }
    
    func handleSpecialOperations(_ input: String) -> Bool {
        switch input {
        case "%":
            percentage()
            return true
        case "+/-":
            toggleSign()
            return true
        case "sqrt":
            squareRoot()
            return true
        default:
            return false
        }
    }
    
    func squareRoot() {
        if currentValue >= 0 {
            currentValue = sqrt(currentValue)
            print("Square root: \(formatNumber(currentValue))")
        } else {
            print("Error: Cannot calculate square root of negative number")
        }
    }
    
    // Enhanced input handling with error checking
    func safeHandleInput(_ input: String) {
        if handleSpecialOperations(input) {
            return
        }
        
        if let number = Double(input) {
            currentValue = number
        } else if isValidOperation(input) {
            setOperation(input)
        } else {
            switch input {
            case "=":
                calculate()
            case "clear", "c":
                clear()
            default:
                print("Invalid input: \(input)")
            }
        }
    }
    
    func isValidOperation(_ op: String) -> Bool {
        return ["+", "-", "*", "/"].contains(op)
    }
}
```

### Homework
Add more advanced operations and test error conditions

---

## Lesson 6: String Manipulation and Display Formatting
**Duration:** 60 minutes

### Learning Objectives
- Handle decimal input properly
- Format numbers for display
- Implement string manipulation for calculator display

### Topics Covered
- String methods and manipulation
- Number formatting
- Decimal handling
- Display state management

### Hands-on Activity
- Implement proper decimal input handling
- Create number formatting functions

```swift
extension Calculator {
    private var displayString: String = "0"
    private var enteringNumber: Bool = false
    
    func inputDigit(_ digit: String) {
        if enteringNumber {
            if displayString.count < 10 { // Limit display length
                displayString += digit
            }
        } else {
            displayString = digit
            enteringNumber = true
        }
        updateCurrentValue()
    }
    
    func inputDecimal() {
        if !displayString.contains(".") {
            if enteringNumber {
                displayString += "."
            } else {
                displayString = "0."
                enteringNumber = true
            }
        }
    }
    
    func updateCurrentValue() {
        if let value = Double(displayString) {
            currentValue = value
        }
    }
    
    func updateDisplay() {
        if enteringNumber {
            return // Keep current display while entering
        }
        
        displayString = formatNumber(currentValue)
    }
    
    func formatNumber(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 8
        formatter.minimumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: number)) ?? "0"
    }
    
    func clearEntry() {
        displayString = "0"
        enteringNumber = false
        currentValue = 0
    }
    
    func clearAll() {
        clearEntry()
        previousValue = 0
        operation = ""
    }
}
```

### Homework
Test decimal input and number formatting with various scenarios

---

## Lesson 7: Memory Functions and State Management
**Duration:** 60 minutes

### Learning Objectives
- Implement memory functions (M+, M-, MR, MC)
- Manage calculator state effectively
- Handle complex operation sequences

### Topics Covered
- Memory storage and retrieval
- State management patterns
- Complex operation chaining
- Data persistence concepts

### Hands-on Activity
- Add memory functions to calculator
- Implement state management

```swift
class Calculator {
    // ... existing properties ...
    private var memory: Double = 0
    private var hasMemoryValue: Bool = false
    
    // Memory functions
    func memoryStore() {
        memory = currentValue
        hasMemoryValue = true
        print("Memory stored: \(formatNumber(memory))")
    }
    
    func memoryRecall() {
        if hasMemoryValue {
            currentValue = memory
            updateDisplay()
            print("Memory recalled: \(formatNumber(memory))")
        } else {
            print("No value in memory")
        }
    }
    
    func memoryAdd() {
        memory += currentValue
        hasMemoryValue = true
        print("Added to memory: \(formatNumber(memory))")
    }
    
    func memorySubtract() {
        memory -= currentValue
        hasMemoryValue = true
        print("Subtracted from memory: \(formatNumber(memory))")
    }
    
    func memoryClear() {
        memory = 0
        hasMemoryValue = false
        print("Memory cleared")
    }
    
    // Enhanced command handling
    func handleMemoryCommands(_ input: String) -> Bool {
        switch input.lowercased() {
        case "ms":
            memoryStore()
            return true
        case "mr":
            memoryRecall()
            return true
        case "m+":
            memoryAdd()
            return true
        case "m-":
            memorySubtract()
            return true
        case "mc":
            memoryClear()
            return true
        default:
            return false
        }
    }
}
```

### Homework
Test memory functions and create complex calculation sequences

---

## Lesson 8: Command History and Undo Functionality
**Duration:** 60 minutes

### Learning Objectives
- Implement command history
- Add undo/redo functionality
- Work with arrays and collections

### Topics Covered
- Arrays and collections in Swift
- Command pattern implementation
- History management
- Stack operations for undo/redo

### Hands-on Activity
- Create command history system
- Implement undo functionality

```swift
struct CalculatorState {
    let currentValue: Double
    let previousValue: Double
    let operation: String
    let displayString: String
}

class Calculator {
    // ... existing properties ...
    private var history: [CalculatorState] = []
    private var historyIndex: Int = -1
    
    func saveState() {
        let state = CalculatorState(
            currentValue: currentValue,
            previousValue: previousValue,
            operation: operation,
            displayString: displayString
        )
        
        // Remove any future history if we're not at the end
        if historyIndex < history.count - 1 {
            history.removeSubrange((historyIndex + 1)...)
        }
        
        history.append(state)
        historyIndex = history.count - 1
        
        // Limit history size
        if history.count > 50 {
            history.removeFirst()
            historyIndex -= 1
        }
    }
    
    func undo() -> Bool {
        guard historyIndex > 0 else {
            print("Cannot undo further")
            return false
        }
        
        historyIndex -= 1
        let state = history[historyIndex]
        restoreState(state)
        print("Undone to: \(formatNumber(currentValue))")
        return true
    }
    
    func redo() -> Bool {
        guard historyIndex < history.count - 1 else {
            print("Cannot redo further")
            return false
        }
        
        historyIndex += 1
        let state = history[historyIndex]
        restoreState(state)
        print("Redone to: \(formatNumber(currentValue))")
        return true
    }
    
    private func restoreState(_ state: CalculatorState) {
        currentValue = state.currentValue
        previousValue = state.previousValue
        operation = state.operation
        displayString = state.displayString
    }
    
    func showHistory() {
        print("Calculation History:")
        for (index, state) in history.enumerated() {
            let marker = index == historyIndex ? "→ " : "  "
            print("\(marker)\(formatNumber(state.currentValue))")
        }
    }
}
```

### Homework
Test undo/redo functionality and implement history display

---

## Lesson 9: Scientific Calculator Functions
**Duration:** 60 minutes

### Learning Objectives
- Add scientific functions (sin, cos, tan, log)
- Work with Swift's math library
- Implement angle mode switching

### Topics Covered
- Foundation math functions
- Radians vs degrees
- Scientific notation
- Advanced mathematical operations

### Hands-on Activity
- Implement scientific calculator functions
- Add trigonometric operations

```swift
import Foundation

extension Calculator {
    enum AngleMode {
        case degrees
        case radians
    }
    
    private var angleMode: AngleMode = .degrees
    
    func setAngleMode(_ mode: AngleMode) {
        angleMode = mode
        print("Angle mode set to: \(mode)")
    }
    
    func sine() {
        let angle = angleMode == .degrees ? currentValue * .pi / 180 : currentValue
        currentValue = sin(angle)
        updateDisplay()
        print("sin(\(formatNumber(currentValue)))")
    }
    
    func cosine() {
        let angle = angleMode == .degrees ? currentValue * .pi / 180 : currentValue
        currentValue = cos(angle)
        updateDisplay()
        print("cos(\(formatNumber(currentValue)))")
    }
    
    func tangent() {
        let angle = angleMode == .degrees ? currentValue * .pi / 180 : currentValue
        currentValue = tan(angle)
        updateDisplay()
        print("tan(\(formatNumber(currentValue)))")
    }
    
    func logarithm() {
        if currentValue > 0 {
            currentValue = log10(currentValue)
            updateDisplay()
            print("log(\(formatNumber(currentValue)))")
        } else {
            print("Error: Logarithm of non-positive number")
        }
    }
    
    func naturalLog() {
        if currentValue > 0 {
            currentValue = log(currentValue)
            updateDisplay()
            print("ln(\(formatNumber(currentValue)))")
        } else {
            print("Error: Natural log of non-positive number")
        }
    }
    
    func power(_ exponent: Double) {
        currentValue = pow(currentValue, exponent)
        updateDisplay()
        print("Result: \(formatNumber(currentValue))")
    }
    
    func handleScientificOperations(_ input: String) -> Bool {
        switch input.lowercased() {
        case "sin":
            sine()
            return true
        case "cos":
            cosine()
            return true
        case "tan":
            tangent()
            return true
        case "log":
            logarithm()
            return true
        case "ln":
            naturalLog()
            return true
        case "deg":
            setAngleMode(.degrees)
            return true
        case "rad":
            setAngleMode(.radians)
            return true
        default:
            return false
        }
    }
}
```

### Homework
Add more scientific functions and test with various inputs

---

## Lesson 10: File I/O and Data Persistence
**Duration:** 60 minutes

### Learning Objectives
- Save and load calculator state
- Work with file I/O in Swift
- Implement data persistence

### Topics Covered
- File handling in Swift
- JSON encoding/decoding
- Data persistence strategies
- Error handling for file operations

### Hands-on Activity
- Implement save/load functionality
- Create data persistence

```swift
import Foundation

extension Calculator {
    struct SavedCalculatorData: Codable {
        let currentValue: Double
        let memory: Double
        let hasMemoryValue: Bool
        let angleMode: String
        let timestamp: Date
    }
    
    private var documentsPath: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, 
                                           in: .userDomainMask)
        return paths[0]
    }
    
    private var saveFileURL: URL {
        return documentsPath.appendingPathComponent("calculator_state.json")
    }
    
    func saveState() {
        let data = SavedCalculatorData(
            currentValue: currentValue,
            memory: memory,
            hasMemoryValue: hasMemoryValue,
            angleMode: angleMode == .degrees ? "degrees" : "radians",
            timestamp: Date()
        )
        
        do {
            let jsonData = try JSONEncoder().encode(data)
            try jsonData.write(to: saveFileURL)
            print("Calculator state saved successfully")
        } catch {
            print("Failed to save state: \(error.localizedDescription)")
        }
    }
    
    func loadState() {
        do {
            let jsonData = try Data(contentsOf: saveFileURL)
            let data = try JSONDecoder().decode(SavedCalculatorData.self, from: jsonData)
            
            currentValue = data.currentValue
            memory = data.memory
            hasMemoryValue = data.hasMemoryValue
            angleMode = data.angleMode == "degrees" ? .degrees : .radians
            
            updateDisplay()
            print("Calculator state loaded successfully")
            print("Last saved: \(DateFormatter.localizedString(from: data.timestamp, dateStyle: .short, timeStyle: .short))")
        } catch {
            print("Failed to load state: \(error.localizedDescription)")
            print("Starting with fresh state")
        }
    }
    
    func exportHistory() {
        let historyData = history.map { state in
            [
                "value": state.currentValue,
                "operation": state.operation,
                "timestamp": Date().timeIntervalSince1970
            ]
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: historyData, options: .prettyPrinted)
            let exportURL = documentsPath.appendingPathComponent("calculator_history.json")
            try jsonData.write(to: exportURL)
            print("History exported to: \(exportURL.path)")
        } catch {
            print("Failed to export history: \(error.localizedDescription)")
        }
    }
}
```

### Homework
Test save/load functionality and implement history export

---

## Lesson 11: Testing and Debugging
**Duration:** 60 minutes

### Learning Objectives
- Write unit tests for calculator functions
- Debug common issues
- Implement comprehensive error handling

### Topics Covered
- XCTest framework basics
- Unit testing strategies
- Debugging techniques
- Performance optimization

### Hands-on Activity
- Create comprehensive test suite
- Debug and fix issues

```swift
import XCTest
@testable import Calculator

class CalculatorTests: XCTestCase {
    
    var calculator: Calculator!
    
    override func setUp() {
        super.setUp()
        calculator = Calculator()
    }
    
    override func tearDown() {
        calculator = nil
        super.tearDown()
    }
    
    func testBasicArithmetic() {
        // Test addition
        calculator.inputNumber(5)
        calculator.setOperation("+")
        calculator.inputNumber(3)
        calculator.calculate()
        XCTAssertEqual(calculator.currentValue, 8, accuracy: 0.001)
        
        // Test subtraction
        calculator.inputNumber(10)
        calculator.setOperation("-")
        calculator.inputNumber(4)
        calculator.calculate()
        XCTAssertEqual(calculator.currentValue, 6, accuracy: 0.001)
        
        // Test multiplication
        calculator.inputNumber(7)
        calculator.setOperation("*")
        calculator.inputNumber(6)
        calculator.calculate()
        XCTAssertEqual(calculator.currentValue, 42, accuracy: 0.001)
        
        // Test division
        calculator.inputNumber(20)
        calculator.setOperation("/")
        calculator.inputNumber(4)
        calculator.calculate()
        XCTAssertEqual(calculator.currentValue, 5, accuracy: 0.001)
    }
    
    func testDivisionByZero() {
        calculator.inputNumber(10)
        calculator.setOperation("/")
        calculator.inputNumber(0)
        calculator.calculate()
        // Should not crash and should handle gracefully
        XCTAssertEqual(calculator.currentValue, 10, accuracy: 0.001)
    }
    
    func testMemoryFunctions() {
        calculator.inputNumber(25)
        calculator.memoryStore()
        
        calculator.inputNumber(10)
        calculator.memoryRecall()
        XCTAssertEqual(calculator.currentValue, 25, accuracy: 0.001)
        
        calculator.inputNumber(5)
        calculator.memoryAdd()
        calculator.memoryRecall()
        XCTAssertEqual(calculator.currentValue, 30, accuracy: 0.001)
    }
    
    func testScientificFunctions() {
        calculator.inputNumber(90)
        calculator.setAngleMode(.degrees)
        calculator.sine()
        XCTAssertEqual(calculator.currentValue, 1, accuracy: 0.001)
        
        calculator.inputNumber(0)
        calculator.cosine()
        XCTAssertEqual(calculator.currentValue, 1, accuracy: 0.001)
    }
    
    func testChainedOperations() {
        calculator.inputNumber(2)
        calculator.setOperation("+")
        calculator.inputNumber(3)
        calculator.setOperation("*")
        calculator.inputNumber(4)
        calculator.calculate()
        XCTAssertEqual(calculator.currentValue, 20, accuracy: 0.001) // (2+3)*4
    }
}

// Performance testing
extension CalculatorTests {
    func testPerformanceExample() {
        measure {
            for _ in 0..<1000 {
                calculator.inputNumber(Double.random(in: 1...100))
                calculator.setOperation(["+", "-", "*", "/"].randomElement()!)
                calculator.inputNumber(Double.random(in: 1...100))
                calculator.calculate()
            }
        }
    }
}
```

### Homework
Write additional tests and fix any discovered bugs

---

## Lesson 12: Final Polish and Extension Ideas
**Duration:** 60 minutes

### Learning Objectives
- Finalize the calculator implementation
- Explore extension possibilities
- Review Swift concepts learned

### Topics Covered
- Code organization and best practices
- Documentation and comments
- Extension possibilities (GUI, web interface)
- Swift language features review

### Hands-on Activity
- Final code cleanup and documentation
- Implement help system
- Discuss next steps

```swift
// Final Calculator with help system and documentation
import Foundation

/**
 * A comprehensive calculator implementation in Swift
 * Supports basic arithmetic, scientific functions, memory operations, and more
 */
class Calculator {
    // MARK: - Properties
    
    /// Current displayed value
    private(set) var currentValue: Double = 0
    
    /// Previous value for operations
    private var previousValue: Double = 0
    
    /// Current operation being performed
    private var operation: String = ""
    
    /// Memory storage
    private var memory: Double = 0
    
    /// Whether memory has a stored value
    private var hasMemoryValue: Bool = false
    
    // MARK: - Help System
    
    func showHelp() {
        print("""
        
        Swift Calculator Help
        ====================
        
        Basic Operations:
        • Numbers: Enter any number (e.g., 123, 45.67)
        • +, -, *, /: Basic arithmetic operations
        • =: Calculate result
        • clear: Clear current entry
        • c: Clear all
        
        Memory Operations:
        • ms: Memory store
        • mr: Memory recall
        • m+: Add to memory
        • m-: Subtract from memory
        • mc: Memory clear
        
        Scientific Functions:
        • sin, cos, tan: Trigonometric functions
        • log: Base-10 logarithm
        • ln: Natural logarithm
        • sqrt: Square root
        • %: Percentage
        • +/-: Toggle sign
        
        Special Commands:
        • deg/rad: Set angle mode for trig functions
        • undo: Undo last operation
        • redo: Redo last undone operation
        • history: Show calculation history
        • save: Save calculator state
        • load: Load saved state
        • help: Show this help
        • quit: Exit calculator
        
        """)
    }
    
    // MARK: - Main Interface
    
    func run() {
        print("🧮 Swift Calculator v1.0")
        print("Type 'help' for commands or 'quit' to exit")
        
        loadState() // Load previous state if available
        
        while true {
            print("\n📟 \(formatNumber(currentValue))")
            print("Enter command: ", terminator: "")
            
            guard let input = readLine()?.trimmingCharacters(in: .whitespaces) else {
                continue
            }
            
            if input.lowercased() == "quit" {
                saveState()
                print("Goodbye! 👋")
                break
            }
            
            if input.lowercased() == "help" {
                showHelp()
                continue
            }
            
            processInput(input)
        }
    }
    
    // MARK: - Extension Ideas Discussion
    
    /**
     * Ideas for extending this calculator:
     * 1. SwiftUI interface for macOS/iOS
     * 2. Web interface using Swift for WebAssembly
     * 3. Complex number support
     * 4. Matrix operations
     * 5. Programming calculator (binary, hex, octal)
     * 6. Graphing capabilities
     * 7. Unit conversions
     * 8. Statistics functions
     */
}

// MARK: - Usage Example
let calculator = Calculator()
calculator.run()
```

### Final Project Presentation
Students present their calculators and discuss:
- What they learned about Swift
- Challenges they overcame
- Ideas for future improvements
- Favorite Swift features discovered

### Next Steps Discussion
- Advanced Swift topics (protocols, generics, error handling)
- iOS development with SwiftUI
- Server-side Swift
- Contributing to open source Swift projects

---

## Key Learning Outcomes

By the end of this course, students will have mastered:

1. **Swift Fundamentals**: Variables, functions, classes, and basic syntax
2. **Object-Oriented Programming**: Classes, methods, and encapsulation
3. **Error Handling**: Proper error management and validation
4. **File I/O**: Reading and writing data to files
5. **Testing**: Writing unit tests and debugging code
6. **Problem-Solving**: Breaking complex problems into manageable parts
7. **Real-World Application**: A fully functional calculator with advanced features

## Assessment Methods

- **Participation**: Active engagement in coding activities (30%)
- **Homework Completion**: Regular practice assignments (30%)
- **Final Project**: Working calculator with all features (40%)

## Required Materials

- Mac/PC with Swift compiler or Xcode
- Text editor or IDE
- Command line familiarity helpful

## Support Resources

- Swift.org documentation
- Swift Playgrounds for experimentation
- Stack Overflow for troubleshooting
- Apple Developer documentation
