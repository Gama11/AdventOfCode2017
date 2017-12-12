using buddy.Should;

class Day12 extends buddy.SingleSuite {
    function new() {
        describe("Day12", {
            it("part1", {
                getGroupZero(
"0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5").length.should.be(6);
            });
        });
    }

    function parseConnections(input:String):Connections {
        var connections = new Connections();
        for (line in input.split("\n")) {
            var regex = ~/([0-9]+) <-> ([\w, ]+)/;
            regex.match(line);
            connections[Std.parseInt(regex.matched(1))] =
                regex.matched(2).split(", ").map(Std.parseInt);
        }
        return connections;
    }

    function getGroupZero(input:String):Array<Int> {
        var connections = parseConnections(input);
        function collectConnections(start:Int, visited:Array<Int>):Array<Int> {
            var connection = connections[start];
            var subPrograms = [start];
            for (program in connection) {
                if (visited.indexOf(program) == -1) {
                    visited.push(program);
                    subPrograms = subPrograms.concat(collectConnections(program, visited));
                }
            }
            return subPrograms;
        }
        return collectConnections(0, [0]);
    }
}

typedef Connections = Map<Int, Array<Int>>;
