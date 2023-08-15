const std = @import("std");
const clap = @import("lib/zig-clap/clap.zig");

const debug = std.debug;
const eql = std.mem.eql;
const io = std.io;
const fs = std.fs;
const fmt = std.fmt;
const base64 = std.base64;
const hash = std.crypto.hash;

const ztool = @import("ztool/ztool.zig");

pub fn main() !void {
    // cli
    const params = comptime clap.parseParamsComptime(
        \\-h, --help             Display this help and exit.
        \\-t, --type <str>...    An option type.
        \\-i, --in <str>...      Input data. It is filename.
        \\-o, --out <str>...     Output data. It is filename.
        \\-k, --key <str>...     Hmac key.
    );

    var diag = clap.Diagnostic{};
    var res = clap.parse(clap.Help, &params, clap.parsers.default, .{
        .diagnostic = &diag,
    }) catch |err| {
        diag.report(io.getStdErr().writer(), err) catch {};
        return err;
    };
    defer res.deinit();

    if (res.args.help != 0) {
        debug.print("--help\n", .{});
        return;
    }

    var typ: []const u8 = "md5";
    for (res.args.type) |t| {
        typ = t;
    }

    var in: []const u8 = "in.txt";
    for (res.args.in) |i| {
        in = i;
    }

    var out: []const u8 = "out.txt";
    for (res.args.out) |o| {
        out = o;
    }

    var key: []const u8 = "";
    for (res.args.key) |k| {
        key = k;
    }

    if (!try ztool.file.existsFile(in)) {
        debug.print("{s} is not exists.\n", .{in});
        return;
    }

    var buff: [65536]u8 = undefined;
    const n = try ztool.file.readFile(in, &buff);

    const in_data = buff[0..n];

    if (eql(u8, typ, "b64en")) {
        var buffer: [ztool.encode.base64CalcSize(in_data)]u8 = undefined;
        const encoded = ztool.encode.base64Encode(in_data, &buffer);

        try ztool.file.writeFile(out, encoded);
        debug.print("success.\n", .{});
    } else if (eql(u8, typ, "b64de")) {
        var buffer: [ztool.encode.base64CalcSizeForSlice(in_data)]u8 = undefined;
        const encoded = ztool.encode.base64Decode(in_data, &buffer);

        try ztool.file.writeFile(out, encoded[0..]);
        debug.print("success.\n", .{});
    } else if (eql(u8, typ, "md5")) {
        const encoded = try ztool.hash.Hash(ztool.hash.Md5).create(in_data);

        try ztool.file.writeFile(out, encoded[0..]);
        debug.print("success.\n", .{});
    } else {
        debug.print("type is error.\n", .{});
    }
}

