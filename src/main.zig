const std = @import("std");
const Io = std.Io;
const lexer = @import("lexer.zig");

const chlisp = @import("chlisp");

const CLIError = error{MissingFileName};

pub fn main(init: std.process.Init) !void {
    const arena: std.mem.Allocator = init.arena.allocator();
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

    var cursor: usize = 0;
    var begin: usize = undefined;
    var end: usize = undefined;
    while (cursor <= file_stat.size) {
        const atom: ?lexer.Atoms = lexer.read_token(file_content, cursor, &begin, &end);

        if (atom == null)
            break;

        const token_size: usize = end - begin;
        const token: []u8 = try arena.alloc(u8, token_size);
        defer arena.free(token);

        @memset(token, 0);
        @memcpy(token, file_content[begin..end]);

        try stdout_writer.print("{d},{d},'{s}': {s}\n", .{ cursor, token_size, token, @tagName(atom.?) });
        cursor = end;
    }
    try stdout_writer.flush();
}
