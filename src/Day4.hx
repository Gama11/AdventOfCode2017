using buddy.Should;
using StringTools;

class Day4 extends buddy.SingleSuite {
    function new() {
        describe("Day4", {
            it("part1", {
                isPassphraseValid1("aa bb cc dd ee").should.be(true);
                isPassphraseValid1("aa bb cc dd aa").should.be(false);
                isPassphraseValid1("aa bb cc dd aaa").should.be(true);

                getValidPassphraseCount(isPassphraseValid1,
"aa bb cc dd ee
aa bb cc dd aa
aa bb cc dd aaa").should.be(2);
            });

            it("part2", {
                isPassphraseValid2("abcde fghij").should.be(true);
                isPassphraseValid2("abcde xyz ecdab").should.be(false);
                isPassphraseValid2("a ab abc abd abf abj").should.be(true);
                isPassphraseValid2("iiii oiii ooii oooi oooo").should.be(true);
                isPassphraseValid2("oiii ioii iioi iiio").should.be(false);
            });
        });
    }

    function getWords(s:String):Array<String> {
        return ~/[ \t]+/g.split(s.trim());
    }

    function isPassphraseValid(words:Array<String>):Bool {
        var wordsSoFar = new Map<String, Bool>();
        for (word in words) {
            if (wordsSoFar.exists(word)) {
                return false;
            }
            wordsSoFar[word] = true;
        }
        return true;
    }

    function isPassphraseValid1(passphrase:String):Bool {
        return isPassphraseValid(getWords(passphrase));
    }

    function isPassphraseValid2(passphrase:String):Bool {
        var words = getWords(passphrase).map(word -> {
            var characters = word.split("");
            characters.sort(Reflect.compare);
            return characters.join("");
        });
        return isPassphraseValid(words);
    }

    function getValidPassphraseCount(isValid:String->Bool, passphrases:String):Int {
        return passphrases.split("\n").map(isValid).filter(valid -> valid).length;
    }
}
