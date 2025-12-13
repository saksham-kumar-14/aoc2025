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
        var nc = c;
        if (line[0] == 'L') {
            nc -= n;
        } else {
            nc += n;
        }

        if(nc > 0){
            ans += @divFloor(nc, 100);
        }else{
            if(c != 0 and c != 100){
                ans += 1;
            }
            ans += @divFloor(-nc, 100);
        }

        std.debug.print("wot {d} - {d}\n", .{nc, ans});

        c = @mod(nc, 100);
    }
    std.debug.print("{d}\n", .{ans});
}
