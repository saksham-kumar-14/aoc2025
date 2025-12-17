const std = @import("std");
const input = @embedFile("./inputs/day07.txt");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var lines = std.mem.tokenizeScalar(u8, input, '\n');

    const first = lines.next().?;
    const width = first.len;

    var beams = try allocator.alloc(u64, width);
    defer allocator.free(beams);
    @memset(beams, 0);

    for (first, 0..) |c, i| {
        if (c == 'S') {
            beams[i] = 1;
            break;
        }
    }

    while (lines.next()) |line| {
        var next = try allocator.alloc(u64, width);
        defer allocator.free(next);
        @memset(next, 0);

        var i: usize = 0;
        while (i < width) : (i += 1) {
            const count = beams[i];
            if (count == 0) continue;

            if (line[i] == '^') {
                if (i > 0) next[i - 1] += count;
                if (i + 1 < width) next[i + 1] += count;
            } else {
                next[i] += count;
            }
        }

        @memcpy(beams, next);
    }

    var ans: u64 = 0;
    for (beams) |v| ans += v;

    std.debug.print("{d}\n", .{ans});
}
