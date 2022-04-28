# frozen_string_literal: true

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
require "libyui/tasks"

target = ENV["LIBYUI_SUBMIT"] || ENV["YAST_SUBMIT"] || :factory
Libyui::Tasks.submit_to(target.to_sym)

Libyui::Tasks.configuration do |conf|
  include Libyui::Tasks::Helpers

  # read package name from spec file name because CWD can have a -branch suffix
  main_spec = Dir.glob("package/*.spec").max
  conf.package_name = main_spec[/package\/(.*)\.spec$/, 1]

  conf.version = cmake_version

  conf.skip_license_check << /bootstrap.sh|ChangeLog|Makefile.cvs/
  conf.skip_license_check << /^buildtools\/.*/
  conf.skip_license_check << /\.(cmake|gv|ui|xpm|qrc)$/
  conf.skip_license_check << /^src\/lang_fonts$/
  conf.skip_license_check << /\.mng$/ # binary
end

# load libyui-rake tasks
task_path = File.expand_path("../tasks", __dir__)
Dir["#{task_path}/*.rake"].each do |f|
  load f
end
