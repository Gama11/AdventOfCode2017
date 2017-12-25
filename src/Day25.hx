using buddy.Should;
using Lambda;

class Day25 extends buddy.SingleSuite {
    function new() {
        describe("Day25", {
            it("part1", {
                run(parse(
"Begin in state A.
Perform a diagnostic checksum after 6 steps.

In state A:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state B.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the left.
    - Continue with state B.

In state B:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state A.
  If the current value is 1:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state A."
                )).should.be(3);
            });
        });
    }

    function parse(input:String):Program {
        var sections = ~/\r?\n\r?\n/g.split(input);

        var headerMatch =
"Begin in state ([A-Z]).
Perform a diagnostic checksum after (\\d+) steps.";
        var headerRegex = new EReg(headerMatch, "");
        headerRegex.match(sections.shift());
        var start = headerRegex.matched(1);
        var steps = Std.parseInt(headerRegex.matched(2));

        var sectionMatch =
"In state ([A-Z]):
  If the current value is ([01]):
    - Write the value ([01]).
    - Move one slot to the (right|left).
    - Continue with state ([A-Z]).
  If the current value is ([01]):
    - Write the value ([01]).
    - Move one slot to the (right|left).
    - Continue with state ([A-Z]).";
        var sectionRegex = new EReg(sectionMatch, "");
        var states = new Map<State, Instruction>();

        for (section in sections) {
            sectionRegex.match(section);
            var state = sectionRegex.matched(1);

            var ifValue = Std.parseInt(sectionRegex.matched(2));
            var ifWrite = Std.parseInt(sectionRegex.matched(3));
            var ifMove = sectionRegex.matched(4);
            var ifSwitch = sectionRegex.matched(5);

            var elseWrite = Std.parseInt(sectionRegex.matched(7));
            var elseMove = sectionRegex.matched(8);
            var elseSwitch = sectionRegex.matched(9);
    
            states[state] = If(ifValue, [
                Write(ifWrite),
                if (ifMove == "left") MoveLeft else MoveRight,
                SwitchState(ifSwitch)
            ], [
                Write(elseWrite),
                if (elseMove == "left") MoveLeft else MoveRight,
                SwitchState(elseSwitch)
            ]);
        }

        return {
            start: start,
            steps: steps,
            states: states
        };
    }

    function run(program:Program):Int {
        var tape = new Map<Int, Value>();
        var position = 0;
        var state = program.start;

        function get(i:Int) {
            if (tape[i] == null) {
                tape[i] = 0;
            }
            return tape[i];
        }

        function runInstruction(instruction:Instruction) {
            switch (instruction) {
                case If(value, body, else_):
                    if (get(position) == value) {
                        for (instruction in body) {
                            runInstruction(instruction);
                        }
                    } else {
                        for (instruction in else_) {
                            runInstruction(instruction);
                        }
                    }

                case Write(value): tape[position] = value;
                case MoveRight: position++;
                case MoveLeft: position--;
                case SwitchState(nextState): state = nextState;
            }
        }

        for (_ in 0...program.steps) {
           runInstruction(program.states[state]);
        }

        return [for (key in tape.keys()) tape[key]].count(value -> value == One);
    }
}

typedef Program = {
    start:State,
    steps:Int,
    states:Map<State, Instruction>
}

typedef State = String;

enum Instruction {
    If(value:Value, body:Array<Instruction>, else_:Array<Instruction>);
    Write(value:Value);
    MoveRight;
    MoveLeft;
    SwitchState(nextState:State);
}

@:enum abstract Value(Int) from Int {
    var Zero = 0;
    var One = 1;
}
