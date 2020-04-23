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

require "packaging"
require_relative "lib/libyui/tasks"
Libyui::Tasks.submit_to :sle15sp2

# build the gem package (replaces the original 'tarball' task)
Rake::Task[:tarball].clear
desc "Build gem package, save it to package subdirectory"
task :tarball do
  version = File.read("VERSION").chomp
  Dir["package/*.tar.bz2"].each { |f| rm f }
  Dir["package/*.gem"].each { |f| rm f }

  sh "gem build libyui-rake.gemspec"
  mv "libyui-rake-#{version}.gem", "package"
end

desc "Install libyui-rake gem package"
task install: :tarball do
  sh "sudo gem install --local package/libyui-rake*.gem"
end

namespace :version do
  task :bump do
    # update VERSION
    version_parts = File.read("VERSION").strip.split(".")
    version_parts[-1] = (version_parts.last.to_i + 1).to_s
    new_version = version_parts.join(".")

    puts "Updating to #{new_version}"
    File.write("VERSION", new_version + "\n")

    # update *.spec file
    spec_file = "package/rubygem-libyui-rake.spec"
    spec = File.read(spec_file)
    spec.gsub!(/^\s*Version:.*$/, "Version:        #{new_version}")
    File.write(spec_file, spec)
  end
end

desc "Pretend to run the test suite"
task :test do
  puts "No tests yet" if verbose
end

Libyui::Tasks.configuration do |conf|
  conf.package_name = "rubygem-libyui-rake"
end
# vim: ft=ruby
