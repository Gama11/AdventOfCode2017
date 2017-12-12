using buddy.Should;

class Day12 extends buddy.SingleSuite {
    function new() {
        describe("Day12", {
            var data =
"0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5";

            it("part1", {
                getGroupZero(data).length.should.be(6);
            });

            it("part2", {
                countGroups(data).should.be(2);
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
        return getGroup(parseConnections(input), 0);
    }

    function getGroup(connections:Connections, start:Int):Array<Int> {
        function collectConnections(start:Int, visited:Array<Int>):Array<Int> {
            var connection = connections[start];
            var subPrograms = [start];
            for (program in connection) {
                if (visited.indexOf(program) == -1) {
                    visited.push(program);
                    subPrograms = subPrograms.concat(
                        collectConnections(program, visited));
                }
            }
            return subPrograms;
        }
        return collectConnections(start, [start]);
    }

    function countGroups(input:String) {
        var connections = parseConnections(input);
        var visitedPrograms = [];
        var groups = 0;
        for (program in connections.keys()) {
            if (visitedPrograms.indexOf(program) == -1) {
                visitedPrograms = visitedPrograms.concat(getGroup(connections, program));
                groups++;
            }
        }
        return groups;
    }
}

typedef Connections = Map<Int, Array<Int>>;
