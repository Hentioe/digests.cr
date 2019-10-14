require "json"
require "digest/md5"

module Digests
  class Manifest
    JSON.mapping(
      digests: Hash(String, FileInfo),
      latest: Hash(String, String),
      version: Int32
    )

    def <<(file_info : FileInfo)
      logical_path = file_info.logical_path
      digest = file_info.digest

      extname = File.extname(logical_path)
      digested = logical_path[0..(logical_path.size - extname.size) - 1] + "-#{digest}#{extname}"
      @digests[digested] = file_info
      @latest[logical_path] = digested
    end

    def initialize(@version : Int32)
      @digests = Hash(String, FileInfo).new
      @latest = Hash(String, String).new
    end
  end

  class FileInfo
    JSON.mapping(
      logical_path: String,
      mtime: Int64,
      size: UInt64,
      digest: String
    )

    def self.from_path(static_path : String, logical_path : String) : FileInfo
      fpath = "#{static_path}#{logical_path}"
      info = File.info fpath
      mtime = info.modification_time.to_unix
      size = info.size

      digest = File.open fpath do |io|
        buffer = Bytes.new(io.size)
        io.read buffer
        Digest::MD5.hexdigest(buffer)
      end

      FileInfo.new(
        logical_path: logical_path,
        mtime: mtime,
        size: size,
        digest: digest
      )
    end

    def initialize(@logical_path, @mtime, @size, @digest)
    end
  end
end
