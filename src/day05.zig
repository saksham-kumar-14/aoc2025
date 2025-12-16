
const std = @import("std");
const input = @embedFile("./inputs/day05.txt");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    var ans: i64 = 0;
    var flag = false;

    var a = std.ArrayList(i64).init(allocator);
    defer a.deinit();
    var b = std.ArrayList(i64).init(allocator);
    defer b.deinit();


    while (lines.next()) |line| {


        if (std.mem.indexOfScalar(u8, line, '-') == null) {
            flag = true;
        }

        if (line.len == 0) {
            flag = true;
            continue;
        }

        if (flag) {
            const n = try std.fmt.parseInt(i64, line, 10);
            var i: usize = 0;
            while(i < a.items.len) : (i += 1) {
                if(a.items[i] <= n and n <= b.items[i]) {
                    ans += 1;
                    break;
                }
            }
        } else {
            var it = std.mem.splitSequence(u8, line, "-");
            const i = it.next() orelse continue;
            const j = it.next() orelse continue;
            const ni = try std.fmt.parseInt(i64, i, 10);
            const nj = try std.fmt.parseInt(i64, j, 10);
            try a.append(ni);
            try b.append(nj);
        }
    }

    std.debug.print("{d}\n", .{ans});
}

