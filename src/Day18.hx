using buddy.Should;
using haxe.Int64;
using StringTools;

class Day18 extends buddy.SingleSuite {
    function new() {
        describe("Day18", {
            it("part2", {
                duet(parse(
"snd 1
snd 2
snd p
rcv a
rcv b
rcv c
rcv d"
                )).should.be(3);
            });
        });
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
                case "snd": Send(value(1));
                case "set": Set(register, value(2));
                case "add": Add(register, value(2));
                case "mul": Multiply(register, value(2));
                case "mod": Modulo(register, value(2));
                case "rcv": Receive(register);
                case "jgz": Jump(value(1), value(2));
                case _: null;
            }
        });
    }

    function duet(instructions:Array<Instruction>):Int {
        var program0 = new Program(0, instructions);
        var program1 = new Program(1, instructions);

        var canExecute0 = true;
        var canExecute1 = true;
        while (canExecute0 || canExecute1) {
            canExecute0 = program0.execute(program1);
            canExecute1 = program1.execute(program0);
        }
        return program1.messagesSent;
    }
}

class Program {
    final id:Int;
    final registers:Map<String, Int64>;
    final instructions:Array<Instruction>;
    final messages:List<Int64>;
    var i = 0;

    public var messagesSent(default, null) = 0;

    public function new(id:Int, instructions:Array<Instruction>) {
        this.id = id;
        registers = ["p" => id];
        this.instructions = instructions;
        messages = new List();
    }

    public function send(value:Int64) {
        messages.add(value);
    }

    public function execute(otherProgram:Program):Bool {
        if (i < 0 || i >= instructions.length) {
            return false;
        }

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

        switch (instructions[i]) {
            case Send(var value):
                otherProgram.send(eval(value));
                messagesSent++;

            case Set(register, var value):
                registers[register] = eval(value);

            case Add(register, var value):
                registers[register] = get(register) + eval(value);

            case Multiply(register, var value):
                registers[register] = get(register) * eval(value);

            case Modulo(register, var value):
                registers[register] = get(register) % eval(value);

            case Receive(_) if (messages.length == 0):
                return false;
            
            case Receive(register):
                registers[register] = messages.pop();

            case Jump(var value, offset) if (eval(value) > 0):
                i += eval(offset).toInt() - 1;

            case _:
        }
        
        i++;
        return true;
    }
}

enum Instruction {
    Send(value:RegisterOrValue);
    Set(register:String, value:RegisterOrValue);
    Add(register:String, value:RegisterOrValue);
    Multiply(register:String, value:RegisterOrValue);
    Modulo(register:String, value:RegisterOrValue);
    Receive(register:String);
    Jump(value:RegisterOrValue, offset:RegisterOrValue);
}

enum RegisterOrValue {
    Register(name:String);
    Value(i:Int);
}
