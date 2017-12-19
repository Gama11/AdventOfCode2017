import util.Grid;
import util.Grid.Movement.*;
using buddy.Should;
using StringTools;

class Day19 extends buddy.SingleSuite {
    function new() {
        describe("Day19", {
            var input =
"     |          
     |  +--+    
     A  |  C    
 F---|----E|--+ 
     |  |  |  D 
     +B-+  +--+ ";

            it("part1", {
                followPath(input).letters.should.be("ABCDEF");
            });

            it("part2", {
                followPath(input).steps.should.be(38);
            });
        });
    }

    function followPath(input:String) {
        var grid = input.split("\n").map(line -> line.replace("\r", "").split(""));
        var position = new Point(grid[0].indexOf("|"), 0);
        var direction = Down;
        var letters = "";
        var steps = 1;

        while (isOnGrid(grid, position)) {
            var cell = grid[position.y][position.x];
            if (~/[A-Z]/.match(cell)) {
                letters += cell;
            }

            var options = switch (cell) {
                case "|" if (direction.isVertical()):
                    [Up, Down];
                case "-" if (direction.isHorizontal()):
                    [Left, Right];
                case "+":
                    [Up, Down, Left, Right];
                case _:
                    [direction];
            }
            options.remove(opposite(direction));

            options = options.filter(point -> {
                var target = position.add(point);
                return isOnGrid(grid, target) && grid[target.y][target.x] != " ";
            });

            if (options.length > 1) {
                throw 'ambigious movement at $position: $options';
            } else if (options.length == 1) {
                direction = options[0];
                position = position.add(direction);
                steps++;
            } else {
                break;
            }
        }

        return {
            letters: letters,
            steps: steps
        };
    }

    function opposite(direction:Point):Point {
        return switch (direction) {
            case Up: Down;
            case Down: Up;
            case Left: Right;
            case Right: Left;
        }
    }

    function isOnGrid(grid:Grid, position:Point):Bool {
        return position.x >= 0 && position.x < grid[0].length
            && position.y >= 0 && position.y < grid.length; 
    }
}

typedef Grid = Array<Array<String>>;
