const std = @import("std");
const input = @embedFile("./inputs/day05.txt");

const Range = struct {
    start: i64,
    end: i64,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var lines = std.mem.tokenizeScalar(u8, input, '\n');

    var ranges = std.ArrayList(Range).init(allocator);
    defer ranges.deinit();

    while (lines.next()) |line| {
        if (line.len == 0) continue;

        var it = std.mem.splitSequence(u8, line, "-");
        const s = it.next() orelse continue;
        const e = it.next() orelse continue;

        const start = try std.fmt.parseInt(i64, s, 10);
        const end = try std.fmt.parseInt(i64, e, 10);

        try ranges.append(.{ .start = start, .end = end });
    }

    std.sort.block(Range, ranges.items, {}, struct {
        fn less(_: void, a: Range, b: Range) bool {
            return a.start < b.start;
        }
    }.less);

    var ans: i64 = 0;

    var cur_start = ranges.items[0].start;
    var cur_end = ranges.items[0].end;

    for (ranges.items[1..]) |r| {
        if (r.start <= cur_end + 1) {
            if (r.end > cur_end) cur_end = r.end;
        } else {
            ans += cur_end - cur_start + 1;
            cur_start = r.start;
            cur_end = r.end;
        }
    }

    ans += cur_end - cur_start + 1;

    std.debug.print("{d}\n", .{ans});
}

