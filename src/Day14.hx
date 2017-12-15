import Day10.knotHash;
import util.Point;
import haxe.ds.HashMap;
using buddy.Should;
using Lambda;

class Day14 extends buddy.SingleSuite {
    final hexToBinary = [
        "0" => "0000",
        "1" => "0001",
        "2" => "0010",
        "3" => "0011",
        "4" => "0100",
        "5" => "0101",
        "6" => "0110",
        "7" => "0111",
        "8" => "1000",
        "9" => "1001",
        "a" => "1010",
        "b" => "1011",
        "c" => "1100",
        "d" => "1101",
        "e" => "1110",
        "f" => "1111"
    ];

    function new() {
        describe("Day14", {
            var grid = createGrid("flqrgnkx");

            it("part1", {
                countSquares(grid).should.be(8108);
            });

            it("part2", {
                countRegions(grid).should.be(1242);
            });
        });
    }

    function createGrid(prefix:String):Grid {
        return [for (i in 0...128) i].map(i -> {
            knotHash('$prefix-$i')
                .split("").map(s -> hexToBinary[s]).join("")
                .split("").map(bit -> if (bit == "0") Free else Used);
        });
    }

    function countSquares(grid:Grid):Int {
        return grid.flatten().count(s -> s == Used);
    }

    function countRegions(grid:Grid):Int {
        var regions = new HashMap<Point, Int>();
        var regionCount = 0;

        var left = new Point(-1, 0);
        var up = new Point(0, -1);
        var down = new Point(0, 1);
        var right = new Point(1, 0);
        var operations = [up, left, down, right];

        for (x in 0...128) {
            for (y in 0...128) {
                if (grid[x][y] == Free) {
                    continue;
                }

                var point = new Point(x, y);
                var region = null;

                for (op in operations) {
                    var neighbor = point.add(op);
                    if (grid[neighbor.x] == null) {
                        continue;
                    }
                    var neighborSquare = grid[neighbor.x][neighbor.y];
                    if (neighborSquare != Used) {
                        continue;
                    }

                    region = regions.get(neighbor);
                    break;
                }

                if (region == null) {
                    regions.set(point, regionCount);
                    regionCount++;
                } else {
                    regions.set(point, region);
                }

                var leftRegion = regions.get(point.add(left));
                var aboveRegion = regions.get(point.add(up));
                if (leftRegion != null && aboveRegion != null && leftRegion != aboveRegion) {
                    for (point in regions.keys()) {
                        if (regions.get(point) == leftRegion) {
                            regions.set(point, aboveRegion);
                        }
                    }
                }
            }
        }

        var regionIDs = [];
        for (region in regions) {
            if (regionIDs.indexOf(region) == -1) {
                regionIDs.push(region);
            }
        }
        return regionIDs.length;
    }
}

typedef Grid = Array<Array<Square>>;

enum Square {
    Free;
    Used;
}
