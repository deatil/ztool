# ztool

ztool 是一个使用 zig 语言开发获取文件摘要的工具


### 环境要求

 - Zig >= 0.11


### 下载安装

~~~cmd
git clone github.com/deatil/ztool
~~~


### 开始使用

编译测试
~~~cmd
zig build run
~~~

运行
~~~cmd
./ztool -h
./ztool --help
./ztool -t=md5 [-i=in.txt] [-o=out.txt] [-k=key_data] [-s=1]
./ztool --type=md5 [--in=in.txt] [--out=out.txt] [--key=key_data] [--show=1]
~~~


### 参数

~~~zig
type: 类型 b64en, b64de, md5, sha1, 
    file_md5, file_sha1, file_sha256, file_hmacmd5, file_hmacsha1, 
    sha224, sha256, sha384, sha512,
    sha3_224, sha3_256, sha3_384, sha3_512, hmac_md5
in:   输入文件, 默认为 in.txt
out:  输出文件, 默认为 out.txt
key:  Hmac时密钥,默认为空
show: 是否在控制台显示结果，默认否
~~~


### 开源协议

*  本软件包遵循 `Apache2` 开源协议发布，在保留本软件包版权的情况下提供个人及商业免费使用。


### 版权

*  本软件包所属版权归 deatil(https://github.com/deatil) 所有。

