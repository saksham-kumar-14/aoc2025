const std = @import("std");
const config = @import("config");
const input = @embedFile("./inputs/day01.txt");
pub fn main() !void {
    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    var c: i32 = 50;
    var ans: i32 = 0;
    while (lines.next()) |line| {
        const len = line.len;
        const slice = line[1..len];
        
        const n = try std.fmt.parseInt(i32, slice, 10);
        if (line[0] == 'L') {
            c -= n;
        } else {
            c += n;
        }

        c = @mod(c, 100);
        if (c == 0) {
            ans += 1;
        }
    }
    std.debug.print("{d}\n", .{ans});
}
