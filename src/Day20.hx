using buddy.Should;

class Day20 extends buddy.SingleSuite {
    function new() {
        describe("Day20", {
            it("part1", {
                getClosestToZero(
"p=< 3,0,0>, v=< 2,0,0>, a=<-1,0,0>
p=< 4,0,0>, v=< 0,0,0>, a=<-2,0,0>"
                ).should.be(0);
            });
        });
    }

    function parse(input:String):Array<Particle> {
        return input.split("\n").map(line -> {
            function parsePoint(input:String):Point3D {
                var values = input.split(",").map(Std.parseInt);
                return {
                    x: values[0],
                    y: values[1],
                    z: values[2]
                };
            }
            var regex = ~/p=<(.*?)>, v=<(.*?)>, a=<(.*?)>/;
            regex.match(line);
            {
                position: parsePoint(regex.matched(1)),
                velocity: parsePoint(regex.matched(2)),
                acceleration: parsePoint(regex.matched(3))
            };
        });
    }

    function getClosestToZero(input:String):Int {
        function manhattanDistance(point:Point3D) {
            return Math.abs(point.x) + Math.abs(point.y) + Math.abs(point.z);
        }

        var particles = parse(input);
        var closest = null;
        var closestDistance = null;
        for (i in 0...particles.length) {
            var distance = manhattanDistance(particles[i].acceleration);
            if (closestDistance == null || closestDistance > distance) {
                closest = i;
                closestDistance = distance;
            }
        }
        return closest;
    }
}

typedef Particle = {
    var position:Point3D;
    var velocity:Point3D;
    var acceleration:Point3D;
}

typedef Point3D = {
    var x:Int;
    var y:Int;
    var z:Int;
}
