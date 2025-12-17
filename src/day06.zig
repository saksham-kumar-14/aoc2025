const std = @import("std");
const input = @embedFile("./inputs/day06.txt");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    var ans: i64 = 0;

    var a = std.ArrayList(i64).init(allocator);
    defer a.deinit();
    var b = std.ArrayList([]const u8).init(allocator);
    defer b.deinit();

    while (lines.next()) |line| {
        var it = std.mem.tokenizeAny(u8, line, " \t\n");
        while(it.next()) |token| {
            if(std.mem.eql(u8, token, "+")){
                try b.append(token);
            }else if(std.mem.eql(u8, token, "*")){
                try b.append(token);
            }else{
                const n = try std.fmt.parseInt(i64, token, 10);
                try a.append(n);
            }
        }
    }

    var i: usize = 0;
    while(i < b.items.len) : (i += 1) {
        var c: i64 = 0;
        if(std.mem.eql(u8, b.items[i], "+")){
            var j: usize = i;
            while(j < a.items.len) : (j += b.items.len) {
                c += a.items[j];
            }
            ans += c;
        }else{
            c = 1;
            var j: usize = i;
            while(j < a.items.len) : (j += b.items.len) {
                c *= a.items[j];
            }
            ans += c;
        }
    }

    std.debug.print("{d}\n", .{ans});
}
