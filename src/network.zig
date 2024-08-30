const std = @import("std");
const ape = @cImport({
    @cInclude("ape/ape_netlib.h");
});

pub fn on_connect_internal(_: [*c]ape.struct__ape_socket, _: [*c]ape.struct__ape_socket, _: [*c]ape.struct__ape_global, _: ?*anyopaque) callconv(.C) void {
    std.debug.print("Connection detected {} !\n", .{std.time.milliTimestamp()});
}

const Server = struct {
    server_socket: [*c]ape.struct__ape_socket,

    fn on_connect(_: @This()) void {}

    fn init(self: @This(), port: u16) void {
        const gape = ape.APE_get();
        self.server_socket = ape.APE_socket_new(ape.APE_SOCKET_PT_TCP, 0, gape);
        self.server_socket.*.callbacks.on_connect = self.on_connect();

        _ = ape.APE_socket_listen(self.server_socket, port, "0.0.0.0", 0, 0);
    }
};

pub fn init() void {
    _ = ape.APE_init();
}

pub fn startLoop() void {
    const gape = ape.APE_get();
    ape.APE_loop_run(gape);
}

pub fn callAsync(comptime callback: anytype, args: anytype) void {
    const gape = ape.APE_get();

    const wrapper = struct {
        fn wrappedCallback(arg: ?*anyopaque) callconv(.C) c_int {
            _ = @call(.auto, callback, @as(@TypeOf(args), @alignCast(@ptrCast(arg.?))).*);
            return 0;
        }
    };

    _ = ape.APE_async(gape, wrapper.wrappedCallback, @constCast(args));
}

pub fn createServer(port: u16) Server {
    const server = Server{};

    server.init(port);

    return server;
}
