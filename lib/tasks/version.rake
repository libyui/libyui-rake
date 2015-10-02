#--
# Copyright (C) 2015 SUSE LLC
#   This library is free software; you can redistribute it and/or modify
# it only under the terms of version 2.1 of the GNU Lesser General Public
# License as published by the Free Software Foundation.
#
#   This library is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
# details.
#
#   You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
#++
namespace :version do
  include Libyui::Tasks::Helpers

  desc "Check that the version numbers are in sync"
  task :check do
    cmake_v = cmake_version
    Dir.glob("package/*.spec").each do |spec_filename|
      spec_v = spec_version(spec_filename)
      if cmake_v != spec_v
        raise "Version mismatch, #{Libyui::Tasks::VERSION_CMAKE}:#{cmake_v} "\
          "#{spec_filename}:#{spec_v}"
      end
    end
    puts cmake_v if verbose
  end

  desc "Increase the last part of version in spec and cmake files"
  task bump: :check do
    v = cmake_version.split(".")  # ["1", "2", "3"]

    patch = v.last.to_i.next.to_s # "4"
    s = File.read(Libyui::Tasks::VERSION_CMAKE)
    s.sub!(/(^SET.*VERSION_PATCH.*)"([^"\n])*"/, "\\1\"#{patch}\"")
    File.write(Libyui::Tasks::VERSION_CMAKE, s)

    v[-1] = patch                 # ["1", "2", "4"]
    version = v.join(".")
    Dir.glob("package/*.spec").each do |spec_filename|
      s = File.read(spec_filename)
      s.gsub!(/^\s*Version:.*$/, "Version:        #{version}")
      File.write(spec_filename, s)
    end
    puts version if verbose
  end
end
