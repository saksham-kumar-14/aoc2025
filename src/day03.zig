const std = @import("std");
const input = @embedFile("./inputs/day03.txt");

pub fn main() !void {
    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    var ans: i32 = 0;

    while (lines.next()) |line| {
        if (line.len == 0) continue;

        var largest: i32 = -1;
        var li: usize = 0;

        var idx: usize = 0;
        while (idx < line.len) : (idx += 1) {
            const n: i32 = line[idx] - '0';
            if (n > largest) {
                largest = n;
                li = idx;
            }
        }

        var sLargest: i32 = -1;

        if (li == line.len - 1) {
            var i: usize = 0;
            while (i < line.len) : (i += 1) {
                if (i == li) continue;
                const n: i32 = line[i] - '0';
                if (n > sLargest) {
                    sLargest = n;
                }
            }

            ans += (sLargest * 10) + largest;
        } else {
            var i: usize = li + 1;
            while (i < line.len) : (i += 1) {
                const n: i32 = line[i] - '0';
                if (n > sLargest) {
                    sLargest = n;
                }
            }

            ans += (largest * 10) + sLargest;
        }
    }

    std.debug.print("{d}\n", .{ans});
}

