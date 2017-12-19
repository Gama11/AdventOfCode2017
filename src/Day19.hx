import util.Grid;
import util.Grid.Movement.*;
using buddy.Should;
using StringTools;

class Day19 extends buddy.SingleSuite {
    function new() {
        describe("Day19", {
            it("part1", {
                followPath(
"     |          
     |  +--+    
     A  |  C    
 F---|----E|--+ 
     |  |  |  D 
     +B-+  +--+"
                ).should.be("ABCDEF");
            });
        });
    }

    function followPath(input:String):String {
        var grid = input.split("\n").map(line -> line.split(""));
        var position = new Point(grid[0].indexOf("|"), 0);
        var direction = Down;
        var letters = "";

        function isOnGrid(position:Point):Bool {
            return position.x >= 0 && position.x < grid[0].length &&
                position.y >= 0 && position.y < grid.length; 
        }

        while (isOnGrid(position)) {
            var cell = grid[position.y][position.x];
            if (~/[A-Z]/.match(cell)) {
                letters += cell;
            }

            var options = switch (cell) {
                case "|" if (direction == Up || direction == Down):
                    [Up, Down];
                case "-" if (direction == Left || direction == Right):
                    [Left, Right];
                case "+":
                    [Up, Down, Left, Right];
                case _:
                    [direction];
            }
            options.remove(opposite(direction));

            for (option in options) {
                var target = position.add(option);
                if (isOnGrid(target) && grid[target.y][target.x] != " ") {
                    direction = option;
                    break;
                }
            }

            position = position.add(direction);
        }
        return letters;
    }

    function opposite(direction:Point):Point {
        return switch (direction) {
            case Up: Down;
            case Down: Up;
            case Left: Right;
            case Right: Left;
        }
    }
}
