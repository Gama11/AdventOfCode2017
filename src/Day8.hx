using buddy.Should;
using StringTools;

class Day8 extends buddy.SingleSuite {
    function new() {
        describe("Day8", {
            var instructions = parse(
"b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10");

            it("part1", {
                getLargestRegister(execute(instructions).registers).should.be(1);
            });

            it("part2", {
                execute(instructions).largestValue.should.be(10);
            });
        });
    }

    function parse(input:String):Array<Instruction> {
        return input.split("\n").map(line -> {
            var regex = ~/(\w+) (inc|dec) (-?[0-9]+) if (\w+) ([!=<>]+) (-?[0-9]+)/;
            regex.match(line.trim());
            var register = regex.matched(1);
            var amount = Std.parseInt(regex.matched(3));
            var operation = if (regex.matched(2) == "inc") {
                Increment(register, amount);
            } else {
                Decrement(register, amount);
            }

            var comparisonOperator = switch (regex.matched(5)) {
                case ">": Greater;
                case ">=": GreaterOrEqual;
                case "<": Less;
                case "<=": LessOrEqual;
                case "==": Equal;
                case "!=": NotEqual;
                case _: null;
            }

            If({operator: comparisonOperator,
                register: regex.matched(4),
                value: Std.parseInt(regex.matched(6))
            }, operation);
        });
    }

    function execute(instructions:Array<Instruction>) {
        var registers = new Map<String, Int>();
        function getRegister(name:String):Int {
            if (registers[name] == null) {
                registers[name] = 0;
            }
            return registers[name];
        }

        var largestValue = 0;
        for (instruction in instructions) {
            function eval(instruction:Instruction) {
                switch (instruction) {
                    case Increment(register, amount):
                        registers[register] = getRegister(register) + amount;

                    case Decrement(register, amount):
                        registers[register] = getRegister(register) - amount;
                    
                    case If(comparison, body):
                        var registerValue = getRegister(comparison.register);
                        if (compare(comparison.operator, registerValue, comparison.value)) {
                            eval(body);
                        }
                }
            }
            eval(instruction);
            largestValue = Std.int(Math.max(largestValue, getLargestRegister(registers)));
        }

        return {
            registers: registers,
            largestValue: largestValue
        };
    }

    function compare(operator:ComparisonOperator, a:Int, b:Int):Bool {
        return switch (operator) {
            case Greater: a > b;
            case GreaterOrEqual: a >= b;
            case Less: a < b;
            case LessOrEqual: a <= b;
            case Equal: a == b;
            case NotEqual: a != b;
        }
    }

    function getLargestRegister(registers:Map<String, Int>):Int {
        var largest = 0;
        for (register in registers) {
            if (register > largest) {
                largest = register;
            }
        }
        return largest;
    }
}

enum Instruction {
    Increment(register:String, amount:Int);
    Decrement(register:String, amount:Int);
    If(comparison:Comparison, body:Instruction);
}

typedef Comparison = {
    operator:ComparisonOperator,
    register:String,
    value:Int
}

enum ComparisonOperator {
    Greater;
    GreaterOrEqual;
    Less;
    LessOrEqual;
    Equal;
    NotEqual;
}
