using haxe.Int64;
using StringTools;

class Day23 extends buddy.SingleSuite {
    function new() {
        trace(execute(parse(
"set b 99
set c b
jnz a 2
jnz 1 5
mul b 100
sub b -100000
set c b
sub c -17000
set f 1
set d 2
set e 2
set g d
mul g e
sub g b
jnz g 2
set f 0
sub e -1
set g e
sub g b
jnz g -8
sub d -1
set g d
sub g b
jnz g -13
jnz f 2
sub h -1
set g b
sub g c
jnz g 2
jnz 1 3
sub b -17
jnz 1 -23"
        )));
    }

    function parse(input:String):Array<Instruction> {
        return input.split("\n").map(line -> {
            var words = line.split(" ").map(word -> word.trim());
            var register:String = words[1];
            inline function value(i:Int) {
                var int = Std.parseInt(words[i]);
                if (int == null) {
                    return Register(words[i]);
                }
                return Value(int);
            }
            switch (words[0]) {
                case "set": Set(register, value(2));
                case "sub": Subtract(register, value(2));
                case "mul": Multiply(register, value(2));
                case "jnz": Jump(value(1), value(2));
                case _: null;
            }
        });
    }

    function execute(instructions:Array<Instruction>):Int {
        var registers = new Map<String, Int64>();
        var multiplications = 0;

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
                case Set(register, var value):
                    registers[register] = eval(value);

                case Subtract(register, var value):
                    registers[register] = get(register) - eval(value);

                case Multiply(register, var value):
                    registers[register] = get(register) * eval(value);
                    multiplications++;

                case Jump(var value, offset) if (eval(value) != 0):
                    i += eval(offset).toInt() - 1;

                case _:
            }
            i++;
        }

        return multiplications;
    }
}

enum Instruction {
    Set(register:String, value:RegisterOrValue);
    Subtract(register:String, value:RegisterOrValue);
    Multiply(register:String, value:RegisterOrValue);
    Jump(value:RegisterOrValue, offset:RegisterOrValue);
}

enum RegisterOrValue {
    Register(name:String);
    Value(i:Int);
}
