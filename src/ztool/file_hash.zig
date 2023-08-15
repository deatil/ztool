const std = @import("std");

const fmt = std.fmt;
const io = std.io;
const fs = std.fs;
const hash = std.crypto.hash;
const hmac = std.crypto.auth.hmac;

const file = @import("file.zig");

// 文件 hash
pub fn FileHash(comptime Hash: type) type {
    return struct {
        const Self = @This();

        pub const mac_length = Hash.digest_length;
        pub const key_length_min = 0;
        pub const key_length = mac_length;
        pub const block_length = 65536;

        pub fn create(p: []const u8) ![mac_length * 2]u8 {
            var file_name: []const u8 = try file.formatPath(p);

            var f = try fs.openFileAbsolute(file_name, .{
                .mode = .read_only,
                .lock = .none,
                .lock_nonblocking = false,
                .intended_io_mode = io.default_mode,
                .allow_ctty = false,
            });
            defer f.close();

            var metadata = try f.metadata();
            var file_size = metadata.size();

            var h = Hash.init(.{});

            var index: usize = 0;
            while (index < file_size) {
                var buffer: [block_length]u8 = undefined;

                const amt = try f.read(buffer[0..]);
                const data = buffer[0..amt];

                h.update(data[0..]);

                if (amt == 0) break;
                index += amt;
            }

            var out: [mac_length]u8 = undefined;
            h.final(out[0..]);

            var encoded = fmt.bytesToHex(out[0..], .lower);

            return encoded;
        }
    };
}

// ==============

// 文件 hmac
pub fn FileHmac(comptime Hash: type) type {
    return struct {
        const Self = @This();

        pub const mac_length = Hash.mac_length;
        pub const key_length_min = 0;
        pub const key_length = mac_length;
        pub const block_length = 65536;

        pub fn create(p: []const u8, key: []const u8) ![mac_length * 2]u8 {
            var file_name: []const u8 = try file.formatPath(p);

            var f = try fs.openFileAbsolute(file_name, .{
                .mode = .read_only,
                .lock = .none,
                .lock_nonblocking = false,
                .intended_io_mode = io.default_mode,
                .allow_ctty = false,
            });
            defer f.close();

            var metadata = try f.metadata();
            var file_size = metadata.size();

            var h = Hash.init(key);

            var index: usize = 0;
            while (index < file_size) {
                var buffer: [block_length]u8 = undefined;

                const amt = try f.read(buffer[0..]);
                const data = buffer[0..amt];

                h.update(data[0..]);

                if (amt == 0) break;
                index += amt;
            }

            var out: [mac_length]u8 = undefined;
            h.final(out[0..]);

            var encoded = fmt.bytesToHex(out[0..], .lower);

            return encoded;
        }
    };
}
