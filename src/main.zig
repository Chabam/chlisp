const std = @import("std");
const Io = std.Io;

const chlisp = @import("chlisp");

const CLIError = error{MissingFileName};

pub fn main(init: std.process.Init) !void {
    var arena: std.mem.Allocator = init.arena.allocator();
    const io = init.io;

    var stderr_buffer: [1024]u8 = undefined;
    var stderr_file_writer: std.Io.File.Writer = .init(std.Io.File.stderr(), io, &stderr_buffer);
    var stderr_writer = &stderr_file_writer.interface;
    const args = try init.minimal.args.toSlice(arena);
    if (args.len < 2) {
        try stderr_writer.print("Missing filename!\n", .{});
        try stderr_writer.flush();
        return CLIError.MissingFileName;
    }

    var stdout_buffer: [1024]u8 = undefined;
    var stdout_file_writer: Io.File.Writer = .init(.stdout(), io, &stdout_buffer);
    const stdout_writer = &stdout_file_writer.interface;

    const file: std.Io.File = try std.Io.Dir.openFile(std.Io.Dir.cwd(), io, args[1], .{});
    defer file.close(io);

    const file_stat = try file.stat(io);

    const file_content: []u8 = try arena.alloc(u8, file_stat.size);
    defer arena.free(file_content);

    _ = try file.readPositionalAll(io, file_content, 0);
    try stdout_writer.print("File content:\n----\n{s}\n----\n", .{file_content});
    try stdout_writer.flush();

    var tokenizer = chlisp.lexer.Tokenizer.init(file_content);
    while (tokenizer.next()) |token| {
        try stdout_writer.print("{d},{d},'{s}': {s}\n", .{ token.begin, token.text.len, token.text, @tagName(token.type) });
    }
    try stdout_writer.flush();

    const val1 = chlisp.value.Value{ .number = 1 };
    const val2 = chlisp.value.Value{ .symbol = @constCast("Allo") };

    const tst = chlisp.pair.Pair.init(val1, val2);
    var env = chlisp.environment.Environment.init(arena);

    try env.addValue(@constCast("val1"), val1);
    try env.addValue(@constCast("val2"), val2);
    try env.addValue(@constCast("pair"), chlisp.value.Value{ .pair = @constCast(&tst) });

    try env.print(stdout_writer);

    if (env.getValue(@constCast("pairs"))) |val| {
        try val.print(stdout_writer);
    } else {
        try stdout_writer.print("{s} is not found", .{"pairs"});
    }

    try stdout_writer.flush();
}
