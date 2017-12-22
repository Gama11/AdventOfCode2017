import haxe.ds.HashMap;
import util.Grid;
import util.Grid.Movement.*;
using buddy.Should;
using StringTools;

class Day22 extends buddy.SingleSuite {
    function new() {
        var input = 
"..#
#..
...";

        describe("Day22", {
            it("part1", {
                simulate1(10000, input).should.be(5587);
            });

            it("part2", {
                simulate2(100, input).should.be(26);
                simulate2(10000000, input).should.be(2511944);
            });
        });
    }

    function parse(input:String) {
        var grid = new HashMap<Point, NodeStatus>();
        var rows = input.split("\n").map(s -> s.trim());
        var center = new Point(
            Math.floor(rows[0].length / 2),
            Math.floor(rows.length / 2));
        for (y in 0...rows.length) {
            var cells = rows[y].split("");
            for (x in 0...rows[y].length) {
                if (cells[x] == "#") {
                    grid.set(new Point(x, y), Infected);
                }
            }
        }
        return {
            grid: grid,
            center: center
        };
    }

    function simulate(bursts:Int, input:String,
        getTurnAmount:NodeStatus->Int, getNextStatus:NodeStatus->NodeStatus):Int {
        var parsed = parse(input);
        var grid = parsed.grid;
        var position = parsed.center;
        var direction = Up;
        var infectionBursts = 0;

        for (_ in 0...bursts) {
            var status = grid.get(position);
            if (status == null) {
                status = Clean;
            }

            direction = turn(direction, getTurnAmount(status));
            
            var nextStatus = getNextStatus(status);
            if (nextStatus == Infected) {
                infectionBursts++;
            }
            grid.set(position, nextStatus);

            position = position.add(direction);
        }

        return infectionBursts;
    }

    function simulate1(bursts:Int, input:String):Int {
        return simulate(bursts, input,
            status -> if (status == Infected) 1 else -1,
            status -> if (status == Infected) Clean else Infected);
    }

    function simulate2(bursts:Int, input:String):Int {
        return simulate(bursts, input,
            status -> switch (status) {
                case Clean: -1;
                case Weakened: 0;
                case Infected: 1;
                case Flagged: 2;
            },
            status -> switch (status) {
                case Clean: Weakened;
                case Weakened: Infected;
                case Infected: Flagged;
                case Flagged: Clean;
            }
        );
    }

    function turn(direction:Point, amount:Int):Point {
        var directions = [Left, Up, Right, Down];
        var directionIndex = directions.indexOf(direction) + amount;
        return directions[mod(directionIndex, directions.length)];
    }

    function mod(a:Int, b:Int) {
        var r = a % b;
        return r < 0 ? r + b : r;
    }
}

enum NodeStatus {
    Clean;
    Weakened;
    Infected;
    Flagged;
}
