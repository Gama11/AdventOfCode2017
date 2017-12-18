using buddy.Should;
using haxe.Int64;
using StringTools;

class Day18 extends buddy.SingleSuite {
    function new() {
        describe("Day18", {
            it("part1", {
                execute(parse(
"set a 1
add a 2
mul a a
mod a 5
snd a
set a 0
rcv a
jgz a -1
set a 1
jgz a -2"
                )).should.be(4);
            });
        });
    }

    function parse(input:String):Array<Instruction> {
        return input.split("\n").map(line -> {
            var words = line.split(" ").map(word -> word.trim());
            var register:String = words[1];
            inline function value() {
                var int = Std.parseInt(words[2]);
                if (int == null) {
                    return Register(words[2]);
                }
                return Value(int);
            }
            switch (words[0]) {
                case "snd": PlaySound(register);
                case "set": Set(register, value());
                case "add": Add(register, value());
                case "mul": Multiply(register, value());
                case "mod": Modulo(register, value());
                case "rcv": Recover(register);
                case "jgz": Jump(register, value());
                case _: null;
            }
        });
    }

    function execute(instructions:Array<Instruction>):Null<Int> {
        var registers = new Map<String, Int64>();
        var frequency = null;

        function get(name:String):Int64 {
            if (registers[name] == null) {
                registers[name] = 0;
            }
            return registers[name];
        }

        function eval(value:RegisterOrValue):Int64 {
            return switch (value) {
                case Register(name): get(name);
                case Value(i): i;
            }
        }

        var i = 0;
        while (i >= 0 && i < instructions.length) {
            switch (instructions[i]) {
                case PlaySound(register):
                    frequency = get(register).toInt();

                case Set(register, var value):
                    registers[register] = eval(value);

                case Add(register, var value):
                    registers[register] = get(register) + eval(value);

                case Multiply(register, var value):
                    registers[register] = get(register) * eval(value);

                case Modulo(register, var value):
                    registers[register] = get(register) % eval(value);

                case Recover(register) if (get(register) != 0):
                    return frequency;

                case Jump(register, offset) if (get(register) > 0):
                    i += eval(offset).toInt() - 1;

                case _:
            }
            
            i++;
        }

        return null;
    }
}

enum Instruction {
    PlaySound(register:String);
    Set(register:String, value:RegisterOrValue);
    Add(register:String, value:RegisterOrValue);
    Multiply(register:String, value:RegisterOrValue);
    Modulo(register:String, value:RegisterOrValue);
    Recover(register:String);
    Jump(register:String, offset:RegisterOrValue);
}

enum RegisterOrValue {
    Register(name:String);
    Value(i:Int);
}
