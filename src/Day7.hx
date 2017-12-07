using buddy.Should;
using StringTools;
using Lambda;

class Day7 extends buddy.SingleSuite {
    function new() {
        describe("Day2", {
            var tower = buildTower(
"pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)");

            it("part1", {
                getName(tower).should.be("tknk");
            });

            it("part2", {
                findBalanceWeight(tower).should.be(60);
            });
        });
    }

    function buildTower(input:String):Tower {
        var parts = new Map<String, Tower>();

        for (line in input.split("\n")) {
            var lineRegex = ~/(\w+) \(([0-9]+)\)(?: -> ([\w, ]+))?/;
            lineRegex.match(line.trim());
            var name = lineRegex.matched(1);
            var weight = Std.parseInt(lineRegex.matched(2));
            var group3 = lineRegex.matched(3);
            var children = if (group3 == null) [] else group3.split(", ");
            
            parts[name] = if (children.length > 0) {
                Node([for (child in children) Leaf(child, 0)], name, weight);
            } else {
                Leaf(name, weight);
            }
        }

        for (part in parts) {
            switch (part) {
                case Node(children, _, _):
                    for (i in 0...children.length) {
                        var childName = getName(children[i]);
                        children[i] = parts[childName];
                        parts.remove(childName);
                    }
                case Leaf(_, _):
            }
        }

        // only the root should be left
        for (part in parts) {
            return part;
        }
        return null;
    }

    function getName(tower:Tower):String {
        return switch (tower) {
            case Node(_, name, _): name;
            case Leaf(name, _): name;
        }
    }
    
    function getWeight(tower:Tower):Int {
        return switch (tower) {
            case Node(_, _, weight): weight;
            case Leaf(_, weight): weight;
        }
    }

    function calculateWeight(tower:Tower):Int {
        return switch (tower) {
            case Node(children, _, weight):
                weight + children.map(calculateWeight).fold((a, b) -> a + b, 0);
            case Leaf(_, weight):
                weight;
        }
    }

    function findBalanceWeight(tower:Tower):Null<Int> {
        switch (tower) {
            case Node(children, _, _):
                var weights =  children.map(calculateWeight);
                for (i in 0...weights.length) {
                    if (weights.count(w -> w == weights[i]) == 1) {
                        var balanceWeight = findBalanceWeight(children[i]);
                        if (balanceWeight != null) {
                            return balanceWeight;
                        }
                        var correctWeight = weights[(i + 1) % weights.length];
                        var weightDifference = weights[i] - correctWeight;
                        return getWeight(children[i]) - weightDifference;
                    }
                }
            case Leaf(_, _):
        }
        return null;
    }
}

enum Tower {
    Node(children:Array<Tower>, name:String, weight:Int);
    Leaf(name:String, weight:Int);
}
