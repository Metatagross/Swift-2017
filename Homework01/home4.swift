
import Foundation

let operators = [
	"^": (prec: 4, assoc: true),
	"*": (prec: 3, assoc: false),
	"/": (prec: 3, assoc: false),
	"+": (prec: 2, assoc: false),
	"-": (prec: 2, assoc: false),
]

class RPN {
	var rpn : [String] = []
	var stack : [String] = []
	
	func parseExpression(_ tokens: [String]) -> [String] {
		for token in tokens {
			switch token {
			case "(":
				self.stack += [token]
			case ")":
				while !self.stack.isEmpty {
					let oper = self.stack.removeLast()
					if oper == "(" { break } 
					else { self.rpn += [oper] }
				}
			default:
				if let first = operators[token] {
					for oper in self.stack.reversed() {
						if let second = operators[oper] {
							if !(first.prec > second.prec || (first.prec == second.prec && first.assoc)) {
								self.rpn += [self.stack.removeLast()]
							}
						} 
					}
					self.stack += [token]
				} else { self.rpn += [token] }
			}
		}
		
		var result = self.rpn
		result += self.stack.reversed()
		return result
	}

	func parseToRPN(_ expression: String) -> [String] {
		let tokens = expression.characters.split{ $0 == " " }.map(String.init)
		let result = parseExpression(tokens).joined(separator: " ")
		return result.components(separatedBy: " ")
	}

	func evaluate(_ tokens: [String]) -> Int {
		for s in tokens {
			switch s {
				case "+":
					let rightVal = Int(self.stack.removeLast())!
					let leftVal = Int(self.stack.removeLast())!
					self.stack.append(String(leftVal + rightVal))
				case "-":
					let rightVal = Int(self.stack.removeLast())!
					let leftVal = Int(self.stack.removeLast())!
					self.stack.append(String(leftVal - rightVal))
				case "*":
					let rightVal = Int(self.stack.removeLast())!
					let leftVal = Int(self.stack.removeLast())!
					self.stack.append(String(leftVal * rightVal))
				case "/":
					let rightVal = Int(self.stack.removeLast())!
					let leftVal = Int(self.stack.removeLast())!
					self.stack.append(String(leftVal / rightVal))
				case "^":
					let rightVal = Int(self.stack.removeLast())!
					let leftVal = Int(self.stack.removeLast())!
					self.stack.append(String(Int(pow(Double(leftVal),Double(rightVal)))))
				default:
					self.stack.append(s)
			}
		}
		return Int(self.stack.removeLast())!
	}
}

class Expression : RPN {
	var variables : [String] = []
	
	var charges : [(variable : String, value: String)] = [];
	
	init(variables: [String]) {
		self.variables = variables
	}
	
	func chargeVariables( _ values: [String]) {
		if self.variables.count == values.count {
			charges = Array(zip(self.variables, values));
		}
	}
	
	func findValue (_ variable: String) -> String {
		if charges.count == 0 {
			return ""
		}
		let tuple = charges.first(where: { $0.variable == variable });
		if tuple != nil {
			return tuple!.value;
		}
		return "";
	}
	
	func calculate(_ expression: String, _ values: [String]) {
		let expr: [String] = parseToRPN(expression)
		self.chargeVariables(values);
		var substituted: [String] = []
		for e in expr {
			if findValue(e) != "" {
				substituted.append(findValue(e))
			} else {
				substituted.append(e)
			}
		}
		print(super.evaluate(substituted))
	}
}

var e: Expression = Expression(variables: ["a", "b", "c"])
e.calculate("( a + b + c ) * 2", ["1", "1", "77"])