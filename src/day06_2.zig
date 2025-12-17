const std = @import("std");
const input = @embedFile("./inputs/day06.txt");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    var ans: i64 = 0;
    var a = std.ArrayList(u8).init(allocator);
    defer a.deinit();
    
    var len: usize = 0;
    while (lines.next()) |line| {
        len = line.len;
        for (line) |ch| {
            try a.append(ch);
        }
    }
    
    if (len == 0 or a.items.len < len) {
        std.debug.print("0\n", .{});
        return;
    }
    
    var i: usize = a.items.len - len;
    var flag: bool = true;
    var c: i64 = 0;
    
    while (i < a.items.len) : (i += 1) {
        if (a.items[i] == '+') {
            ans += c;
            flag = true;
            c = 0;
        } else if (a.items[i] == '*') {
            ans += c;
            flag = false;
            c = 1;
        }
        
        var n = std.ArrayList(u8).init(allocator);
        defer n.deinit();
        
        if (i >= len) {
            var j: usize = i - len;
            while (true) {
                if (a.items[j] != ' ') {
                    try n.insert(0, a.items[j]);
                }
                if (j < len) break;
                j -= len;
            }
        }
        
        if (n.items.len > 0) {
            const no = try std.fmt.parseInt(i64, n.items, 10);
            if (flag) {
                c += no;
            } else {
                c *= no;
            }
        }
    }
    
    ans += c;
    std.debug.print("{d}\n", .{ans});
}
