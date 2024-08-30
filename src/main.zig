const std = @import("std");
const ape = @cImport({
    @cInclude("ape/ape_netlib.h");
});

const net = @import("network.zig");

// pub fn on_connect(_: [*c]ape.struct__ape_socket, client: [*c]ape.struct__ape_socket, _: [*c]ape.struct__ape_global, _: ?*anyopaque) callconv(.C) void {
//     std.debug.print("Connection detected {} !\n", .{std.time.milliTimestamp()});

//     _ = ape.APE_socket_write(client, @constCast("Hello\n"), 6, ape.APE_DATA_STATIC);
// }

fn testcall(x: ?[]const u8) void {
    if (x) |xx| {
        std.debug.print("Call {s}\n", .{xx});
    } else {
        std.debug.print("Got null value\n", .{});
    }
}

pub fn main() !void {
    std.debug.print("Start\n", .{});

    net.init();

    net.callAsync(testcall, &.{null});
    net.startLoop();
}
