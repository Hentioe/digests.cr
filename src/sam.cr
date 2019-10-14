require "sam"
require "./digests"

namespace "digests" do
  desc "Digests static files"
  task "make" do |_, argv|
    args =
      if static_path = argv[0]?
        static_path = static_path.as(String)
        Digests.run static_path
      else
        Digests.run
      end
  end

  desc "Removes digested static files"
  task "clean" do |_, argv|
    args =
      if static_path = argv[0]?
        static_path = static_path.as(String)
        Digests.clean static_path: static_path, digested: true
      else
        Digests.clean digested: true
      end
  end

  desc "Removes undigested static files"
  task "clean_undigested" do |_, argv|
    args =
      if static_path = argv[0]?
        static_path = static_path.as(String)
        Digests.clean static_path: static_path, digested: false
      else
        Digests.clean digested: false
      end
  end
end

