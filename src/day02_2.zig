const std = @import("std");
const input = @embedFile("./inputs/day02.txt");

pub fn main() !void {
    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    var ans: i64 = 0;

    while (lines.next()) |line| {
        var it = std.mem.splitSequence(u8, line, ",");

        while (it.next()) |part| {
            if (part.len == 0) continue;

            const clean = std.mem.trim(u8, part, " \r");
            var it2 = std.mem.splitSequence(u8, clean, "-");

            const start_str = it2.next() orelse continue;
            const end_str = it2.next() orelse continue;

            var n = try std.fmt.parseInt(i64, start_str, 10);
            const end = try std.fmt.parseInt(i64, end_str, 10);

            while (n <= end) : (n += 1) {
                if(f(n)) {
                    std.debug.print("- {d}\n", .{n});
                    ans += n;
                }
            }
        }
    }

    std.debug.print("{d}\n", .{ans});
}

fn f(n: i64) bool {
    if (n < 10) return false;

    var tmp = n;
    var digits: i64 = 0;
    while (tmp > 0) : (tmp = @divFloor(tmp, 10)) {
        digits += 1;
    }

    var bd: i64 = 1;
    const dig2 = @divFloor(digits,2);
    while (bd <= dig2) : (bd += 1) {
        const bp =
            std.math.powi(i64, 10, bd) catch continue;

        const pow =
            std.math.powi(i64, 10, digits - bd) catch continue;

        const block = @divFloor(n , pow);

        var built: i64 = 0;
        var reps: i64 = 0;

        while (built < n) {
            built = built * bp + block;
            reps += 1;
        }

        if (built == n and reps >= 2) {
            return true;
        }
    }

    return false;
}

