const std = @import("std");
const Console = @import("console.zig").Console;
const ShoppingList = @import("shopping_list.zig").ShoppingList;

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer: std.Io.File.Writer = .init(.stdout(), init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

    var stdin_buffer: [1024]u8 = undefined;
    var stdin_reader: std.Io.File.Reader = .init(.stdin(), init.io, &stdin_buffer);
    const stdin = &stdin_reader.interface;

    const arena: std.mem.Allocator = init.arena.allocator();

    const console: Console = .{ .stdin = stdin, .stdout = stdout };
    var shoppingList: ShoppingList = .init(&console, arena);
    defer shoppingList.deinit();

    try shoppingList.run();
}
