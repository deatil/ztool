const std = @import("std");

const io = std.io;
const fs = std.fs;

// 格式化路径
pub fn formatPath(f: []const u8) ![]const u8 {
    var file_name: []const u8 = f;

    if (!fs.path.isAbsolute(f)) {
        var buf: [fs.MAX_PATH_BYTES]u8 = undefined;
        var dir_path = try fs.selfExeDirPath(&buf);

        const allocator = std.heap.page_allocator;
        const filename = try fs.path.join(allocator, &[_][]const u8{dir_path, f,});

        file_name = filename[0..];
    }
    
    return file_name;
}

// 判断文件
pub fn existsFile(p: []const u8) !bool {
    var file_name: []const u8 = try formatPath(p);

    if (fs.openFileAbsolute(file_name, .{
        .mode = .read_only,
        .lock = .none,
        .lock_nonblocking = false,
        .intended_io_mode = io.default_mode,
        .allow_ctty = false,
    })) |f| {
        defer f.close();

        return true;
    } else |err| {
        return switch (err) {
            fs.File.OpenError.FileNotFound => false,
            else => true,
        };
    }
}

// 读取文件
pub fn readFile(p: []const u8) ![]const u8 {
    var file_name: []const u8 = try formatPath(p);

    var f = try fs.openFileAbsolute(file_name, .{
        .mode = .read_only,
        .lock = .none,
        .lock_nonblocking = false,
        .intended_io_mode = io.default_mode,
        .allow_ctty = false,
    });
    defer f.close();

    const gpa = std.heap.page_allocator;

    const file_length = (try f.metadata()).size();
    const constent = try f.readToEndAlloc(gpa, file_length);

    return constent;
}

// 写入文件
pub fn writeFile(p: []const u8, data: []const u8) !void {
    var file_name: []const u8 = try formatPath(p);

    var f = try fs.createFileAbsolute(file_name, .{
        .read = false,
        .truncate = true,
        .exclusive = false,
        .lock = .none,
        .lock_nonblocking = false,
        .mode = fs.File.default_mode,
        .intended_io_mode = io.default_mode,
    });
    defer f.close();

    try f.writeAll(data);
}
