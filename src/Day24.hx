using buddy.Should;
using StringTools;
using Lambda;

class Day24 extends buddy.SingleSuite {
    function new() {
        describe("Day24", {
            var input = 
"0/2
2/2
2/3
3/4
3/5
0/1
10/1
9/10";

            it("part1", {
                getStrongestBridgeStrength(input).should.be(31);
            });

            it("part2", {
                getLongestBridgeStrength(input).should.be(19);
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

    function getBestBridgeStrength(components:Array<Component>, getUtility:Bridge->Int, tieBreaker:Bridge->Int):Int {
        function loop(bridge:Bridge, leftovers:Array<Component>):Bridge {
            var desiredPort = if (bridge.length == 0) 0 else bridge[bridge.length - 1];
            var options = leftovers.filter(c -> c.left == desiredPort || c.right == desiredPort);
            if (options.length == 0) {
                return bridge;
            }

            var bestUtility = 0;
            var bestBridge = [];

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
                var bridge = loop(newBridge, newLeftovers);
                var utility = getUtility(bridge);
                if (utility > bestUtility ||
                    (utility == bestUtility && tieBreaker(bridge) > tieBreaker(bestBridge))) {
                    bestUtility = utility;
                    bestBridge = bridge;
                }
            }

            return bestBridge;
        }
        return getBridgeStrength(loop([], components));
    }

    function getStrongestBridgeStrength(input:String):Int {
        return getBestBridgeStrength(parse(input), getBridgeStrength, null);
    }

    function getLongestBridgeStrength(input:String):Int {
        return getBestBridgeStrength(parse(input), bridge -> bridge.length, getBridgeStrength);
    }

    function getBridgeStrength(bridge:Bridge):Int {
        return bridge.fold((a, b) -> a + b, 0);
    }
}

typedef Component = {
    final left:Int;
    final right:Int;
}

typedef Bridge = Array<Int>;
