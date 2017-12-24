using buddy.Should;
using StringTools;
using Lambda;

class Day24 extends buddy.SingleSuite {
    function new() {
        describe("Day24", {
            it("part1", {
                getMaxBridgeStrength(parse(
"0/2
2/2
2/3
3/4
3/5
0/1
10/1
9/10"
                )).should.be(31);
            });
        });
    }

    function parse(input:String):Array<Component> {
        return input.split("\n").map(line -> {
            var split = line.trim().split("/");
            return {
                left: Std.parseInt(split[0]),
                right: Std.parseInt(split[1])
            };
        });
    }

    function getMaxBridgeStrength(components:Array<Component>):Int {
        function loop(bridge:Array<Int>, leftovers:Array<Component>):Int {
            var desiredPort = if (bridge.length == 0) 0 else bridge[bridge.length - 1];
            var options = leftovers.filter(c -> c.left == desiredPort || c.right == desiredPort);
            if (options.length == 0) {
                return bridge.fold((a, b) -> a + b, 0);
            }
            var maxStrength = 0;
            for (option in options) {
                var newBridge = bridge.copy();
                if (desiredPort == option.left) {
                    newBridge.push(option.left);
                    newBridge.push(option.right);
                } else {
                    newBridge.push(option.right);
                    newBridge.push(option.left);
                }
                var newLeftovers = leftovers.copy();
                newLeftovers.remove(option);
                var strength = loop(newBridge, newLeftovers);
                if (strength > maxStrength) {
                    maxStrength = strength;
                }
            }
            return maxStrength;
        }
        return loop([], components);
    }
}

typedef Component = {
    final left:Int;
    final right:Int;
}
