import Foundation

let operators = [
	"^": (prec: 4, assoc: true),
	"*": (prec: 3, assoc: false),
	"/": (prec: 3, assoc: false),
	"+": (prec: 2, assoc: false),
	"-": (prec: 2, assoc: false),
]
 
func parseExpression(_ tokens: [String]) -> [String] {
	var rpn : [String] = []
	var stack : [String] = []
	
	for token in tokens {
		switch token {
		case "(":
			stack += [token]
		case ")":
			while !stack.isEmpty {
				let oper = stack.removeLast()
				if oper == "(" { break } 
				else { rpn += [oper] }
			}
		default:
			if let first = operators[token] {
				for oper in stack.reversed() {
					if let second = operators[oper] {
						if !(first.prec > second.prec || (first.prec == second.prec && first.assoc)) {
							rpn += [stack.removeLast()]
						}
					} 
				}
				stack += [token]
			} else { rpn += [token] }
		}
	}
	
	var result = rpn
	result += stack.reversed()
	return result
}
 
func parseToRPN(_ expression: String) -> [String] {
	let tokens = expression.characters.split{ $0 == " " }.map(String.init)
	let result = parseExpression(tokens).joined(separator: " ")
	return result.components(separatedBy: " ")
}

func evaluate(_ tokens: [String]) -> Int {
	var stack = [String]()
	for s in tokens {
		switch s {
			case "+":
				let rightVal = Int(stack.removeLast())!
				let leftVal = Int(stack.removeLast())!
				stack.append(String(leftVal + rightVal))
			case "-":
				let rightVal = Int(stack.removeLast())!
				let leftVal = Int(stack.removeLast())!
				stack.append(String(leftVal - rightVal))
			case "*":
				let rightVal = Int(stack.removeLast())!
				let leftVal = Int(stack.removeLast())!
				stack.append(String(leftVal * rightVal))
			case "/":
				let rightVal = Int(stack.removeLast())!
				let leftVal = Int(stack.removeLast())!
				stack.append(String(leftVal / rightVal))
			case "^":
				let rightVal = Int(stack.removeLast())!
				let leftVal = Int(stack.removeLast())!
				stack.append(String(Int(pow(Double(leftVal),Double(rightVal)))))
			default:
				stack.append(s)
		}
	}
	return Int(stack.removeLast())!
}

var expression : String = "( ( 7 * 3 ) ^ 2 - ( 8 / 4 ) ^ 6 + 9 * 5 ) / 10"
let result = parseToRPN(expression)
print(evaluate(result))