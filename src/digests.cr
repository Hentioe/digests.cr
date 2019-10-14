require "file_utils"
require "./digests/manifest"

module Digests
  VERSION = "0.1.0"

  MANIFEST_FILE_NAME = "cache_manifest.json"
  IGNORE_FILES       = [
    MANIFEST_FILE_NAME,
    "favicon.ico",
    "rebots.txt",
  ]

  @@manifest = Manifest.new 1

  def self.logical_path(path : String)
    ENV["DIGESTS_ENV"]? == "dev" ? path : @@manifest.latest[path]?
  end

  def self.init(static_path : String = "static")
    @@manifest = Manifest.from_json(File.read("#{static_path}/#{MANIFEST_FILE_NAME}"))
  end

  def self.run(static_path : String = "static")
    raise Exception.new "Invalid directory: #{static_path}" unless Dir.exists?(static_path)
    # 缓存所有子文件
    logical_file_list = gen_child_list static_path, static_path
    # 生成 Manifest
    logical_file_list.each do |logical_path|
      file_info = FileInfo.from_path static_path, logical_path
      @@manifest << file_info
      source = "#{static_path}#{logical_path}"
      target = "#{static_path}#{@@manifest.latest[logical_path]}"
      FileUtils.cp source, target
    end

    manifest_file = File.open "#{static_path}/#{MANIFEST_FILE_NAME}", "w+"
    manifest_file.puts @@manifest.to_pretty_json
    manifest_file.close
  end

  def self.clean(static_path : String = "static", digested : Bool = true)
    gen_child_list(static_path, static_path, digested: digested).each do |logical_path|
      fpath = "#{static_path}#{logical_path}"
      FileUtils.rm fpath
    end
    FileUtils.rm "#{static_path}/#{MANIFEST_FILE_NAME}" if digested
  end

  alias FileList = Array(String)

  private def self.gen_child_list(root_path : String,
                                  path : String,
                                  list : FileList = FileList.new,
                                  digested : Bool = false) : FileList
    dir = Dir.new path
    dir.children.each do |fname|
      fpath = "#{path}/#{fname}"
      if File.file?(fpath) && !IGNORE_FILES.includes?(fname)
        logical_path = "/" + fpath.[(root_path.size + 1)..fpath.size]
        list << logical_path if digested?(fname) == digested
      else
        gen_child_list root_path, fpath, list, digested unless IGNORE_FILES.includes?(fname)
      end
    end
    list
  end

  RE_DIGESTED_FNAME = /.-.{32}(\..+$|$)/

  private def self.digested?(fname : String) : Bool
    if i = RE_DIGESTED_FNAME =~ fname
      i >= 0
    else
      false
    end
  end
end
