using buddy.Should;

class Day3 extends buddy.SingleSuite {
    function new() {
        describe("Day3", {
            it("part1", {
                steps(1).should.be(0);
                steps(12).should.be(3);
                steps(23).should.be(2);
                steps(1024).should.be(31);
            });
        });
    }

    function steps(square:Int):Int {
        return 0;
    }
}
