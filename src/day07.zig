const std = @import("std");
const input = @embedFile("./inputs/day07.txt");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var lines = std.mem.tokenizeScalar(u8, input, '\n');

    var ans: i64 = 0;

    var beams = std.ArrayList(usize).init(allocator);
    defer beams.deinit();

    var started = false;

    while (lines.next()) |line| {
        if (!started) {
            var i: usize = 0;
            while (i < line.len) : (i += 1) {
                if (line[i] == 'S') {
                    started = true;
                    try beams.append(i);
                    break;
                }
            }
            continue;
        }

        var next = std.ArrayList(usize).init(allocator);

        for (beams.items) |col| {
            if (line[col] == '^') {
                ans += 1;

                if (col > 0 and !contains(&next, col - 1))
                    try next.append(col - 1);

                if (col + 1 < line.len and !contains(&next, col + 1))
                    try next.append(col + 1);
            } else {
                if (!contains(&next, col))
                    try next.append(col);
            }
        }

        beams.deinit();
        beams = next;
    }

    std.debug.print("{d}\n", .{ans});
}

fn contains(list: *std.ArrayList(usize), value: usize) bool {
    for (list.items) |v| {
        if (v == value) return true;
    }
    return false;
}
