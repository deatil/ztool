const std = @import("std");
const clap = @import("lib/zig-clap/clap.zig");

const debug = std.debug;
const eql = std.mem.eql;
const io = std.io;

const ztool = @import("ztool/ztool.zig");

/// ztool 
/// 
/// @create 2023-8-15
/// @author deatil
pub fn main() !void {
    // cli
    const params = comptime clap.parseParamsComptime(
        \\-h, --help             Display this help and exit.
        \\-t, --type <str>...    An option type.
        \\-i, --in <str>...      Input data. It is filename.
        \\-o, --out <str>...     Output data. It is filename.
        \\-k, --key <str>...     Hmac key.
        \\-s, --show <usize>     Show result at console.
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

    var typ: []const u8 = "";
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

    var show: bool = false;
    if (res.args.show) |s| {
        if (s == 1) { 
            show = true;
        } else { 
            show = false;
        }
    }

    if (!try ztool.file.existsFile(in)) {
        debug.print("{s} is not exists.\n", .{in});
        return;
    }

    var alloc = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer alloc.deinit();

    var success: bool = true;
    var data: []const u8 = undefined;

    if (eql(u8, typ, "b64en")) {
        // ./ztool -t b64en
        const in_data = try ztool.file.readFile(in);

        const in_len = ztool.encode.base64CalcSize(in_data);
        var buffer = try alloc.allocator().alloc(u8, in_len);

        const encoded = ztool.encode.base64Encode(in_data, buffer);

        data = encoded;
    } else if (eql(u8, typ, "b64de")) {
        // ./ztool -t=b64de
        const in_data = try ztool.file.readFile(in);

        const in_len = ztool.encode.base64CalcSizeForSlice(in_data);
        var buffer = try alloc.allocator().alloc(u8, in_len);

        const decoded = ztool.encode.base64Decode(in_data, buffer);

        data = decoded[0..];
    } else if (eql(u8, typ, "file_md5")) {
        // ./ztool -t=file_md5
        const encoded = try ztool.file_hash.FileHash(ztool.hash.Md5).create(in);

        data = encoded[0..];
    } else if (eql(u8, typ, "file_sha1")) {
        // ./ztool -t=file_sha1
        const encoded = try ztool.file_hash.FileHash(ztool.hash.Sha1).create(in);

        data = encoded[0..];
    } else if (eql(u8, typ, "file_sha256")) {
        // ./ztool -t=file_sha256
        const encoded = try ztool.file_hash.FileHash(ztool.hash.Sha256).create(in);

        data = encoded[0..];
    } else if (eql(u8, typ, "file_hmacmd5")) {
        // ./ztool -t=file_hmacmd5 -k=sdfds
        const encoded = try ztool.file_hash.FileHmac(ztool.hash.HmacMd5).create(in, key);

        data = encoded[0..];
    } else if (eql(u8, typ, "file_hmacsha1")) {
        // ./ztool -t=file_hmacsha1 -k=sdfds
        const encoded = try ztool.file_hash.FileHmac(ztool.hash.HmacSha1).create(in, key);

        data = encoded[0..];
    } else if (eql(u8, typ, "md5")) {
        // ./ztool -t=md5 -s=1
        const in_data = try ztool.file.readFile(in);
        const encoded = try ztool.hash.Hash(ztool.hash.Md5).create(in_data);

        data = encoded[0..];
    } else if (eql(u8, typ, "sha1")) {
        // ./ztool -t=sha1 -s=1
        const in_data = try ztool.file.readFile(in);
        const encoded = try ztool.hash.Hash(ztool.hash.Sha1).create(in_data);

        data = encoded[0..];
    } else if (eql(u8, typ, "sha224")) {
        // ./ztool -t=sha224 -s=1
        const in_data = try ztool.file.readFile(in);
        const encoded = try ztool.hash.Hash(ztool.hash.Sha224).create(in_data);

        data = encoded[0..];
    } else if (eql(u8, typ, "sha256")) {
        // ./ztool -t=sha256 -s=1
        const in_data = try ztool.file.readFile(in);
        const encoded = try ztool.hash.Hash(ztool.hash.Sha256).create(in_data);

        data = encoded[0..];
    } else if (eql(u8, typ, "sha384")) {
        // ./ztool -t=sha384 -s=1
        const in_data = try ztool.file.readFile(in);
        const encoded = try ztool.hash.Hash(ztool.hash.Sha384).create(in_data);

        data = encoded[0..];
    } else if (eql(u8, typ, "sha512")) {
        // ./ztool -t=sha512 -s=1
        const in_data = try ztool.file.readFile(in);
        const encoded = try ztool.hash.Hash(ztool.hash.Sha512).create(in_data);

        data = encoded[0..];
    } else if (eql(u8, typ, "sha3_224")) {
        // ./ztool -t=sha3_224 -s=1
        const in_data = try ztool.file.readFile(in);
        const encoded = try ztool.hash.Hash(ztool.hash.Sha3_224).create(in_data);

        data = encoded[0..];
    } else if (eql(u8, typ, "sha3_256")) {
        // ./ztool -t=sha3_256 -s=1
        const in_data = try ztool.file.readFile(in);
        const encoded = try ztool.hash.Hash(ztool.hash.Sha3_256).create(in_data);

        data = encoded[0..];
    } else if (eql(u8, typ, "sha3_384")) {
        // ./ztool -t=sha3_384 -s=1
        const in_data = try ztool.file.readFile(in);
        const encoded = try ztool.hash.Hash(ztool.hash.Sha3_384).create(in_data);

        data = encoded[0..];
    } else if (eql(u8, typ, "sha3_512")) {
        // ./ztool -t=sha3_512 -s=1
        const in_data = try ztool.file.readFile(in);
        const encoded = try ztool.hash.Hash(ztool.hash.Sha3_512).create(in_data);

        data = encoded[0..];
    } else if (eql(u8, typ, "hmac_md5")) {
        // ./ztool -t=hmac_md5 -k=sdfds
        const in_data = try ztool.file.readFile(in);
        const encoded = try ztool.hash.Hmac(ztool.hash.HmacMd5).create(in_data, key);

        data = encoded[0..];
    } else {
        success = false;
    }

    if (success) {
        try ztool.file.writeFile(out, data);

        if (show) {
            debug.print("result is: {s}\n", .{data});
        }

        debug.print("from data [{s}] hash data to [{s}] success.\n", .{in, out});
    } else {
        debug.print("type is error.\n", .{});
    }
}

