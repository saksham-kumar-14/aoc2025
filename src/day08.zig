
const std = @import("std");
const input = @embedFile("./inputs/day08.txt");

const Point = struct {
    x: i64,
    y: i64,
    z: i64,
};

const Edge = struct {
    u: usize,
    v: usize,
    d: i128,
};

const DSU = struct {
    parent: []usize,
    size: []usize,

    fn init(allocator: std.mem.Allocator, n: usize) !DSU {
        var p = try allocator.alloc(usize, n);
        var s = try allocator.alloc(usize, n);
        var i: usize = 0;
        while (i < n) : (i += 1) {
            p[i] = i;
            s[i] = 1;
        }
        return .{ .parent = p, .size = s };
    }

    fn find(self: *DSU, x: usize) usize {
        if (self.parent[x] != x)
            self.parent[x] = self.find(self.parent[x]);
        return self.parent[x];
    }

    fn unite(self: *DSU, a: usize, b: usize) void {
        const ra = self.find(a);
        const rb = self.find(b);
        if (ra == rb) return;

        if (self.size[ra] < self.size[rb]) {
            self.parent[ra] = rb;
            self.size[rb] += self.size[ra];
        } else {
            self.parent[rb] = ra;
            self.size[ra] += self.size[rb];
        }
    }
};

fn dist2(a: Point, b: Point) i128 {
    const dx = @as(i128, a.x) - b.x;
    const dy = @as(i128, a.y) - b.y;
    const dz = @as(i128, a.z) - b.z;
    return dx * dx + dy * dy + dz * dz;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var points = std.ArrayList(Point).init(allocator);
    defer points.deinit();

    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |line| {
        if (line.len == 0) continue;
        var it = std.mem.splitSequence(u8, line, ",");
        try points.append(.{
            .x = try std.fmt.parseInt(i64, it.next().?, 10),
            .y = try std.fmt.parseInt(i64, it.next().?, 10),
            .z = try std.fmt.parseInt(i64, it.next().?, 10),
        });
    }

    const n = points.items.len;

    var edges = std.ArrayList(Edge).init(allocator);
    defer edges.deinit();

    var i: usize = 0;
    while (i < n) : (i += 1) {
        var j: usize = i + 1;
        while (j < n) : (j += 1) {
            try edges.append(.{
                .u = i,
                .v = j,
                .d = dist2(points.items[i], points.items[j]),
            });
        }
    }

    std.sort.heap(Edge, edges.items, {}, struct {
        fn less(_: void, a: Edge, b: Edge) bool {
            return a.d < b.d;
        }
    }.less);

    var dsu = try DSU.init(allocator, n);
    defer allocator.free(dsu.parent);
    defer allocator.free(dsu.size);

    const k = 1000;
    var idx: usize = 0;
    while (idx < k) : (idx += 1) {
        const e = edges.items[idx];
        dsu.unite(e.u, e.v);
    }

    var map = std.AutoHashMap(usize, usize).init(allocator);
    defer map.deinit();

    i = 0;
    while (i < n) : (i += 1) {
        const r = dsu.find(i);
        const entry = try map.getOrPut(r);
        if (!entry.found_existing)
            entry.value_ptr.* = 0;
        entry.value_ptr.* += 1;
    }

    var sizes = std.ArrayList(usize).init(allocator);
    defer sizes.deinit();

    var it = map.iterator();
    while (it.next()) |e| {
        try sizes.append(e.value_ptr.*);
    }

    std.sort.heap(usize, sizes.items, {}, struct {
        fn less(_: void, a: usize, b: usize) bool {
            return a > b;
        }
    }.less);

    const ans = sizes.items[0] * sizes.items[1] * sizes.items[2];
    std.debug.print("{d}\n", .{ans});
}

