
const std = @import("std");
const input = @embedFile("./inputs/day04.txt");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var lines = std.mem.tokenizeScalar(u8, input, '\n');

    var rows: usize = 0;
    var cols: usize = 0;

    var tmp = lines;
    while (tmp.next()) |line| {
        if (cols == 0) cols = line.len;
        rows += 1;
    }

    const grid = try allocator.alloc([]u8, rows);
    defer {
        for (grid) |row| allocator.free(row);
        allocator.free(grid);
    }

    for (grid) |*row| {
        row.* = try allocator.alloc(u8, cols);
    }

    lines = std.mem.tokenizeScalar(u8, input, '\n');
    var r: usize = 0;
    while (lines.next()) |line| {
        @memcpy(grid[r], line);
        r += 1;
    }

    const rLen = grid.len;
    const cLen = grid[0].len;
    var ans: i32 = 0;

    for (grid, 0..) |row, i| {
        for (row, 0..) |ch, j| {
            if (ch != '@') continue;

            var cnt: i32 = 0;

            if (i > 0 and j > 0 and grid[i - 1][j - 1] == '@') cnt += 1;
            if (i > 0 and grid[i - 1][j] == '@') cnt += 1;
            if (i > 0 and j + 1 < cLen and grid[i - 1][j + 1] == '@') cnt += 1;

            if (j > 0 and grid[i][j - 1] == '@') cnt += 1;
            if (j + 1 < cLen and grid[i][j + 1] == '@') cnt += 1;

            if (i + 1 < rLen and j > 0 and grid[i + 1][j - 1] == '@') cnt += 1;
            if (i + 1 < rLen and grid[i + 1][j] == '@') cnt += 1;
            if (i + 1 < rLen and j + 1 < cLen and grid[i + 1][j + 1] == '@') cnt += 1;

            if (cnt < 4) {
                ans += 1;
            }
        }
    }

    std.debug.print("{d}\n", .{ans});
}

