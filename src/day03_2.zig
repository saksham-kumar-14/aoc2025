const std = @import("std");
const input = @embedFile("./inputs/day03.txt");

pub fn main() !void {
    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    var ans: i64 = 0;

    while (lines.next()) |line| {
        if (line.len < 12) continue;

        var i: usize = 0;
        var j: usize = line.len - 12;
        var c: i64 = 0;

        var k: usize = 0;
        while (k < 12) : (k += 1) {
            var l: usize = i;
            var largest: i64 = -1;
            var li: usize = i;

            while (l <= j) : (l += 1) {
                const n: i64 = line[l] - '0';
                if (n > largest) {
                    largest = n;
                    li = l;
                }
            }

            c = c * 10 + largest;

            j += 1;
            i = li + 1;
        }

        ans += c;
    }

    std.debug.print("{d}\n", .{ans});
}

