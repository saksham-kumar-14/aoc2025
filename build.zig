const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    
    const days = [_][]const u8{
        "day01",
        "day01_2",
        "day02",
        "day02_2",
        "day03",
        "day03_2",
        "day04",
        "day04_2",
        "day05",
        "day05_2",
        "day06",
        "day06_2",
    };
    
    for (days) |day| {
        const exe = b.addExecutable(.{
            .name = day,
            .root_source_file = b.path(b.fmt("src/{s}.zig", .{day})),
            .target = target,
            .optimize = optimize,
        });
        
        // Remove the .define() call - it's not valid for this use case
        // Instead, you can use addOptions() or handle the path in your code
        
        b.installArtifact(exe);
        
        const run_cmd = b.addRunArtifact(exe);
        run_cmd.step.dependOn(b.getInstallStep());
        
        if (b.args) |args| {
            run_cmd.addArgs(args);
        }
        
        const run_step = b.step(day, b.fmt("Run {s}", .{day}));
        run_step.dependOn(&run_cmd.step);
    }
}
