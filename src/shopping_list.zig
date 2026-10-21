const std = @import("std");
const Console = @import("console.zig").Console;
const Color = @import("console.zig").Color;

pub const ShoppingList = struct {
    console: *const Console,
    items: std.StringHashMap(u32),
    allocator: std.mem.Allocator,

    fn displayPrompt(self: *ShoppingList) void {
        const prompt =
            \\1. Add an item
            \\2. Show shopping list
            \\3. Remove an item
            \\4. Quit
        ;
        self.console.print(prompt, .{});
    }

    pub fn run(self: *ShoppingList) !void {
        while (true) {
            self.displayPrompt();
            const selection = self.console.getInt("Selection: ") catch return error.EndOfStream;
            switch (selection) {
                1 => {
                    self.console.print("", .{});
                    const raw_item = try self.console.getInput("Item: ");
                    const item = try self.allocator.dupe(u8, raw_item);
                    const quantity = try self.console.getInt("Quantity: ");
                    try self.addItem(item, quantity);
                },
                2 => {
                    self.console.print("", .{});
                    self.showShoppingList();
                },
                3 => {
                    self.console.print("", .{});
                    const raw_item = try self.console.getInput("Item to remove: ");
                    const item = try self.allocator.dupe(u8, raw_item);
                    self.removeItem(item);
                },
                4 => {
                    self.console.print("", .{});
                    self.console.print("Quitting...", .{});
                    break;
                },
                else => {
                    self.console.print("", .{});
                    self.console.print("Invalid choice.", .{});
                },
            }
            self.console.print("", .{});
        }
    }

    pub fn init(console: *const Console, allocator: std.mem.Allocator) ShoppingList {
        return .{ .console = console, .items = .init(allocator), .allocator = allocator };
    }

    pub fn deinit(self: *ShoppingList) void {
        self.items.deinit();
    }

    fn showShoppingList(self: *ShoppingList) void {
        if (self.items.count() == 0) {
            self.console.print(Color.green ++ "There is nothing in the shopping list." ++ Color.reset, .{});
            return;
        }

        self.console.print(Color.green ++ "Shopping list:\n" ++ Color.reset, .{});

        var iter = self.items.iterator();
        while (iter.next()) |pair| {
            self.console.print(Color.blue ++ "Item: " ++ Color.yellow ++ "{s}\n" ++ Color.blue ++ "Quantity: " ++ Color.yellow ++ "{d}\n" ++ Color.reset, .{ pair.key_ptr.*, pair.value_ptr.* });
        }
    }

    fn addItem(self: *ShoppingList, item: []const u8, quantity: u32) !void {
        try self.items.put(item, quantity);
    }

    fn removeItem(self: *ShoppingList, item: []const u8) void {
        self.console.print("", .{});
        if (self.items.remove(item)) {
            self.console.print(Color.green ++ "Item removed successfully." ++ Color.reset, .{});
        } else {
            self.console.print(Color.red ++ "Item not found." ++ Color.reset, .{});
        }
    }
};
