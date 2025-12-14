const std = @import("std");
const input = @embedFile("./inputs/day02.txt");

pub fn main() !void {
    var lines = std.mem.tokenizeScalar(u8, input, '\n');

    var ans: i64 = 0;

    while (lines.next()) |line| {
        var it = std.mem.splitSequence(u8, line, ",");

        while (it.next()) |part| {
            var it2 = std.mem.splitSequence(u8, part, "-");

            const i = it2.next() orelse continue;
            const j = it2.next() orelse continue;

            var ni = try std.fmt.parseInt(i64, i, 10);
            const nj = try std.fmt.parseInt(i64, j, 10);

            while (ni <= nj) : (ni += 1) {
                const k: i64 = @as(i64, @intFromFloat(std.math.log10(@as(f64, @floatFromInt(ni))))) + 1;
                if(@mod(k, 2) == 0){
                    const k2:i64 = @divFloor(k, 2);
                    const t: i64 = try std.math.powi(i64, 10, k2);
                    const l: i64 = @mod(ni, t);
                    const n: i64 = (l * t) + l;
                    if(n == ni){
                        ans += n;
                    }
                }
            }
        }
    }

    std.debug.print("{d}\n", .{ans});
}

