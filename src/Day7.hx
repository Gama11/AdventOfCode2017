using buddy.Should;
using StringTools;

class Day7 extends buddy.SingleSuite {
    function new() {
        describe("Day2", {
            it("part1", {
                getName(buildTower(
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
cntj (57)"
                )).should.be("tknk");
            });
        });
    }

    function buildTower(input:String):Tower {
        var parts = new Map<String, Tower>();

        for (line in input.split("\n")) {
            var lineRegex = ~/(\w+) \(([0-9]+)\)(?: -> ([\w, ]+))?/;
            lineRegex.match(line.trim());
            var name = lineRegex.matched(1);
            var id = Std.parseInt(lineRegex.matched(2));
            var group3 = lineRegex.matched(3);
            var children = if (group3 == null) [] else group3.split(", ");
            
            parts[name] = if (children.length > 0) {
                Node([for (child in children) Leaf(child, 0)], name, id);
            } else {
                Leaf(name, id);
            }
        }

        for (part in parts) {
            switch (part) {
                case Node(children, name, id):
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
}

enum Tower {
    Node(children:Array<Tower>, name:String, id:Int);
    Leaf(name:String, id:Int);
}
