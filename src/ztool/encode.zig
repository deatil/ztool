const std = @import("std");

const fmt = std.fmt;
const base64 = std.base64;

pub fn bytesToHex(input: anytype) [input.len * 2]u8 {
    var encoded = fmt.bytesToHex(input, .lower);

    return encoded;
}

// var out: [input.len]u8 = undefined;
// const encoded = ztool.encode.hexToBytes(input, &out);
pub fn hexToBytes(input: []const u8, out: []u8) []u8 {
    var empty: []u8 = "";

    var res = fmt.hexToBytes(out, input) catch empty;

    return res;
}

// ============

pub fn base64CalcSize(input: []const u8) usize {
    var input_len = base64.standard.Encoder.calcSize(input.len);

    return input_len;
}

// var buffer: [base64CalcSize(input)]u8 = undefined;
// const encoded = base64Encode(input, &buffer);
pub fn base64Encode(input: []const u8, buffer: []u8) []const u8 {
    const res = base64.standard.Encoder.encode(buffer, input);

    return res[0..];
}

pub fn base64CalcSizeForSlice(input: []const u8) usize {
    var input_len = base64.standard.Decoder.calcSizeForSlice(input) catch 100;

    return input_len;
}

// var buffer: [base64CalcSizeForSlice(input)]u8 = undefined;
// const encoded = base64Decode(input, &buffer);
pub fn base64Decode(input: []const u8, buffer: []u8) []u8 {
    const decoder = base64.standard.Decoder;
    const input_len = decoder.calcSizeForSlice(input) catch 100;

    var decoded = buffer[0..input_len];
    _ = decoder.decode(decoded, input) catch {};

    return decoded[0..];
}

// ============

pub fn base64NoPadCalcSize(input: []const u8) usize {
    var input_len = base64.standard_no_pad.Encoder.calcSize(input.len);

    return input_len;
}

// var buffer: [base64NoPadCalcSize(input)]u8 = undefined;
// const encoded = base64NoPadEncode(input, &buffer);
pub fn base64NoPadEncode(input: []const u8, buffer: []u8) []const u8 {
    const res = base64.standard_no_pad.Encoder.encode(buffer, input);

    return res[0..];
}

pub fn base64NoPadCalcSizeForSlice(input: []const u8) usize {
    var input_len = base64.standard_no_pad.Decoder.calcSizeForSlice(input) catch 100;

    return input_len;
}

// var buffer: [base64NoPadCalcSizeForSlice(input)]u8 = undefined;
// const encoded = base64NoPadDecode(input, &buffer);
pub fn base64NoPadDecode(input: []const u8, buffer: []u8) []u8 {
    const decoder = base64.standard_no_pad.Decoder;
    const input_len = decoder.calcSizeForSlice(input) catch 100;

    var decoded = buffer[0..input_len];
    _ = decoder.decode(decoded, input) catch {};

    return decoded[0..];
}

// ============

pub fn base64UrlSafeCalcSize(input: []const u8) usize {
    var input_len = base64.url_safe.Encoder.calcSize(input.len);

    return input_len;
}

pub fn base64UrlSafeEncode(input: []const u8, buffer: []u8) []const u8 {
    const res = base64.url_safe.Encoder.encode(buffer, input);

    return res[0..];
}

pub fn base64UrlSafeCalcSizeForSlice(input: []const u8) usize {
    var input_len = base64.url_safe.Decoder.calcSizeForSlice(input) catch 100;

    return input_len;
}

pub fn base64UrlSafeDecode(input: []const u8, buffer: []u8) []u8 {
    const decoder = base64.url_safe.Decoder;
    const input_len = decoder.calcSizeForSlice(input) catch 100;

    var decoded = buffer[0..input_len];
    _ = decoder.decode(decoded, input) catch {};

    return decoded[0..];
}

// ============

pub fn base64UrlSafeNoPadCalcSize(input: []const u8) usize {
    var input_len = base64.url_safe_no_pad.Encoder.calcSize(input.len);

    return input_len;
}

pub fn base64UrlSafeNoPadEncode(input: []const u8, buffer: []u8) []const u8 {
    const res = base64.url_safe_no_pad.Encoder.encode(buffer, input);

    return res[0..];
}

pub fn base64UrlSafeNoPadCalcSizeForSlice(input: []const u8) usize {
    var input_len = base64.url_safe_no_pad.Decoder.calcSizeForSlice(input) catch 100;

    return input_len;
}

pub fn base64UrlSafeNoPadDecode(input: []const u8, buffer: []u8) []u8 {
    const decoder = base64.url_safe_no_pad.Decoder;
    const input_len = decoder.calcSizeForSlice(input) catch 100;

    var decoded = buffer[0..input_len];
    _ = decoder.decode(decoded, input) catch {};

    return decoded[0..];
}