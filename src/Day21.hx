using buddy.Should;
using StringTools;
using Lambda;

class Day21 extends buddy.SingleSuite {
    function new() {
        describe("Day21", {
            it("part1", {
                fractal(2,
"../.# => ##./#../...
.#./..#/### => #..#/..../..../#..#"
                ).should.be(12);
            });
        });
    }

    function parseRules(input:String):Array<Rule> {
        return input.split("\n").map(rule -> {
            var components = rule.split(" => ");
            {
                from: Grid.parse(components[0]),
                to: Grid.parse(components[1])
            };
        });
    }

    function fractal(iterations:Int, input:String):Int {
        var rules = parseRules(input);
        var pattern = Grid.parse(".#./..#/###");
        for (i in 0...iterations) {
            var size = if (pattern.size % 2 == 0) 2 else 3;
            pattern = Grid.combine(pattern.divide(size).map(grid -> {
                var rotated = grid.rotate();
                var rotatedFlippedX = rotated.flipX();
                var flippedX = grid.flipX();
                var flippedY = grid.flipY();
                var variants = [
                    grid, flippedX, flippedY, flippedY.flipX(),
                    rotated, rotatedFlippedX,
                    rotatedFlippedX.flipY(), rotated.flipY()
                ];                
                rules.find(rule -> variants.exists(grid -> grid.equals(rule.from))).to;
            }));
        }
        return pattern.get().flatten().count(s -> s == "#");
    }
}

abstract Grid<T>(Array<Array<T>>) from Array<Array<T>> {
    public var size(get, never):Int;
    
    public static function parse(input:String):Grid<String> {
        return input.split("/").map(row -> row.trim().split(""));
    }

    public function flipX():Grid<T> {
        var grid = copy();
        for (row in 0...size) {
            grid[row].reverse();
        }
        return grid;
    }

    public function flipY():Grid<T> {
        var grid = copy();
        for (x in 0...size) {
            for (y in 0...size) {
                grid[x][y] = this[size - x - 1][size - y - 1];
            }
        }
        return grid;
    }

    public function rotate():Grid<T> {
        var grid = copy();
        for (x in 0...size) {
            for (y in 0...size) {
                grid[x][y] = this[y][x];
            }
        }
        return grid;
    }

    public function divide(targetSize:Int):Grid<Grid<T>> {
        if (size % targetSize != 0) {
            throw 'grid of size $size not evenly divisible by $targetSize';
        }

        var gridCount = Std.int(size / targetSize);
        var grids = [for (i in 0...gridCount) [for (j in 0...gridCount) [for (k in 0...targetSize) []]]];
        for (x in 0...size) {
            var targetX = Std.int(x / targetSize);
            for (y in 0...size) {
                var targetY = Std.int(y / targetSize);
                grids[targetX][targetY][x % targetSize][y % targetSize] = this[x][y];
            } 
        }
        return grids;
    }

    public static function combine<T>(grid:Grid<Grid<T>>):Grid<T> {
        var joined = [for (i in 0...grid[0][0].size * grid.size) []];
        for (x in 0...grid.size) {
            for (y in 0...grid.size) {
                var innnerGrid = grid[x][y];
                var innerSize = innnerGrid.size;
                for (xx in 0...innerSize) {
                    for (yy in 0...innerSize) {
                        joined[x * innerSize + xx][y * innerSize + yy] = innnerGrid[xx][yy];
                    }
                }
            }
        }
        return joined;
    }

    public function map(f:T->T):Grid<T> {
        var grid = copy();
        for (x in 0...size) {
            for (y in 0...size) {
                grid[x][y] = f(grid[x][y]);
            }
        }
        return grid;
    }

    public function copy():Grid<T> {
        var grid = [];
        for (row in 0...size) {
            grid[row] = this[row].copy();
        }
        return grid;
    }

    public function equals(grid:Grid<T>):Bool {
        for (x in 0...size) {
            for (y in 0...size) {
                if (grid[x][y] != this[x][y]) {
                    return false;
                }
            } 
        }
        return true;
    }

    inline function get_size():Int {
        return this.length;
    }

    @:arrayAccess function access(i:Int) {
        return this[i];
    }

    public function get() {
        return this;
    }

    function toString():String {
        return "\n" + this.map(row -> row.join("")).join("\n");
    }
}

typedef Rule = {
    from:Grid<String>,
    to:Grid<String>
}
