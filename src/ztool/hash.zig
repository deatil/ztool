const std = @import("std");

const fmt = std.fmt;
const hash = std.crypto.hash;
const hmac = std.crypto.auth.hmac;

pub const Md5 = hash.Md5;
pub const Sha1 = hash.Sha1;

// Sha224 | Sha256 | Sha384 | Sha512
pub const Sha224 = hash.sha2.Sha224;
pub const Sha256 = hash.sha2.Sha256;
pub const Sha384 = hash.sha2.Sha384;
pub const Sha512 = hash.sha2.Sha512;

pub const Sha3_224 = hash.sha3.Sha3_224;
pub const Sha3_256 = hash.sha3.Sha3_256;
pub const Sha3_384 = hash.sha3.Sha3_384;
pub const Sha3_512 = hash.sha3.Sha3_512;
pub const Keccak256 = hash.sha3.Keccak256;
pub const Keccak512 = hash.sha3.Keccak512;
pub const Shake128 = hash.sha3.Shake128;
pub const Shake256 = hash.sha3.Shake256;

pub const Blake2s128 = hash.blake2.Blake2s128;
pub const Blake2s160 = hash.blake2.Blake2s160;
pub const Blake2s224 = hash.blake2.Blake2s224;
pub const Blake2s256 = hash.blake2.Blake2s256;

pub const Blake3 = hash.Blake3;

// 数据 hash
pub fn Hash(comptime Hasher: type) type {
    return struct {
        const Self = @This();

        pub const mac_length = Hasher.digest_length;
        pub const key_length_min = 0;
        pub const key_length = mac_length;

        hash: Hasher,

        pub fn create(in: []const u8) ![]u8 {
            var out: [mac_length]u8 = undefined;

            var h = Hasher.init(.{});
            h.update(in);
            h.final(out[0..]);

            // lower | upper
            var encoded = fmt.bytesToHex(out[0..], .lower);

            return encoded[0..];
        }

        pub fn hasher() Hasher {
            return hash;
        }
    };
}

// ==============

pub const HmacMd5 = hmac.HmacMd5;
pub const HmacSha1 = hmac.HmacSha1;

pub const HmacSha224 = hmac.sha2.HmacSha224;
pub const HmacSha256 = hmac.sha2.HmacSha256;
pub const HmacSha384 = hmac.sha2.HmacSha384;
pub const HmacSha512 = hmac.sha2.HmacSha512;

// 数据 hmac
pub fn Hmac(comptime Hasher: type) type {
    return struct {
        const Self = @This();

        pub const mac_length = Hasher.mac_length;
        pub const key_length_min = 0;
        pub const key_length = mac_length;

        hash: Hasher,

        pub fn create(in: []const u8, key: []const u8) ![]u8 {
            var out: [mac_length]u8 = undefined;

            var h = Hasher.init(key);
            h.update(in);
            h.final(out[0..]);

            // pub const Case = enum { lower, upper };
            var encoded = fmt.bytesToHex(out[0..], .lower);

            return encoded[0..];
        }

        pub fn hasher() Hasher {
            return hash;
        }
    };
}