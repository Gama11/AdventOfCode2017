import haxe.ds.HashMap;
import util.Grid;
import util.Grid.Movement.*;
using buddy.Should;
using StringTools;

class Day22 extends buddy.SingleSuite {
    function new() {
        describe("Day22", {
            it("part1", {
                simulate(10000,
"..#
#..
..."
                ).should.be(5587);
            });
        });
    }

    function parse(input:String) {
        var grid = new HashMap<Point, Bool>();
        var rows = input.split("\n").map(s -> s.trim());
        var center = new Point(
            Math.floor(rows[0].length / 2),
            Math.floor(rows.length / 2));
        for (y in 0...rows.length) {
            var cells = rows[y].split("");
            for (x in 0...rows[y].length) {
                if (cells[x] == "#") {
                    grid.set(new Point(x, y), true);
                }
            }
        }
        return {
            grid: grid,
            center: center
        };
    }

    function simulate(bursts:Int, input:String):Int {
        var parsed = parse(input);
        var grid = parsed.grid;
        var position = parsed.center;
        var direction = Up;
        var directions = [Left, Up, Right, Down];
        var infectionBursts = 0;

        for (_ in 0...bursts) {
            var infected = grid.exists(position);
            var directionChange = if (infected) 1 else -1;
            var directionIndex = directions.indexOf(direction) + directionChange;
            direction = directions[mod(directionIndex, directions.length)];

            if (infected) {
                grid.remove(position);
            } else {
                grid.set(position, true);
                infectionBursts++;
            }

            position = position.add(direction);
        }

        return infectionBursts;
    }

    function mod(a:Int, b:Int) {
        var r = a % b;
        return r < 0 ? r + b : r;
    }
}
