const std = @import("std");

pub const Console = struct {
    stdin: *std.Io.Reader,
    stdout: *std.Io.Writer,

    pub fn print(self: *const Console, comptime message: []const u8, args: anytype) void {
        self.stdout.print(message ++ "\n", args) catch return;
        self.stdout.flush() catch return;
    }

    pub fn getInput(self: *const Console, comptime prompt: []const u8) ![]const u8 {
        try self.stdout.writeAll(Color.cyan ++ prompt ++ Color.reset);
        try self.stdout.flush();
        const response = try self.stdin.takeDelimiter('\n') orelse return error.EndOfStream;
        return std.mem.trim(u8, response, " \r\t");
    }

    pub fn getInt(self: *const Console, comptime prompt: []const u8) !u32 {
        while (true) {
            const input = try self.getInput(prompt);
            return std.fmt.parseInt(u32, input, 10) catch {
                self.print(Color.red ++ "Invalid input. Please enter a valid positive number." ++ Color.reset, .{});
                continue;
            };
        }
    }
};

pub const Color = struct {
    pub const red = "\x1b[31m";
    pub const green = "\x1b[32m";
    pub const yellow = "\x1b[33m";
    pub const blue = "\x1b[34m";
    pub const cyan = "\x1b[36m";
    pub const reset = "\x1b[0m";
};
