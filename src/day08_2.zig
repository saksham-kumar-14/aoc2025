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
    comps: usize,

    fn init(allocator: std.mem.Allocator, n: usize) !DSU {
        var p = try allocator.alloc(usize, n);
        var s = try allocator.alloc(usize, n);
        var i: usize = 0;
        while (i < n) : (i += 1) {
            p[i] = i;
            s[i] = 1;
        }
        return .{ .parent = p, .size = s, .comps = n };
    }

    fn find(self: *DSU, x: usize) usize {
        if (self.parent[x] != x)
            self.parent[x] = self.find(self.parent[x]);
        return self.parent[x];
    }

    fn unite(self: *DSU, a: usize, b: usize) bool {
        const ra = self.find(a);
        const rb = self.find(b);
        if (ra == rb) return false;

        if (self.size[ra] < self.size[rb]) {
            self.parent[ra] = rb;
            self.size[rb] += self.size[ra];
        } else {
            self.parent[rb] = ra;
            self.size[ra] += self.size[rb];
        }
        self.comps -= 1;
        return true;
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

    var last_u: usize = 0;
    var last_v: usize = 0;

    for (edges.items) |e| {
        if (dsu.unite(e.u, e.v)) {
            last_u = e.u;
            last_v = e.v;
            if (dsu.comps == 1) break;
        }
    }

    const ans = points.items[last_u].x * points.items[last_v].x;
    std.debug.print("{d}\n", .{ans});
}

