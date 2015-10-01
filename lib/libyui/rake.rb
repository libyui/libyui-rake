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

Libyui::Tasks.configuration do |conf|
  include Libyui::Tasks::Helpers

  if ENV["LIBYUI_SUBMIT"] == "SLES"
    conf.obs_api        = "https://api.suse.de/"
    conf.obs_project    = "Devel:YaST:Head"
    conf.obs_target     = "SLE-12-SP1"
    conf.obs_sr_project = "SUSE:SLE-12-SP1:GA"
  else
    conf.obs_project    = "devel:libraries:libyui"
    conf.obs_sr_project = "openSUSE:Factory"
  end

  # read package name from spec file name because CWD can have a -branch suffix
  main_spec = Dir.glob("package/*.spec").sort.last
  conf.package_name = main_spec[/package\/(.*)\.spec$/, 1]

  conf.version = cmake_version

  conf.skip_license_check << /.*/ if conf.package_name =~ /gtk|bindings/
  conf.skip_license_check << /bootstrap.sh|ChangeLog|Makefile.cvs/
  conf.skip_license_check << /^buildtools\/.*/
  conf.skip_license_check << /\.(cmake|gv|ui|xpm)$/
  conf.skip_license_check << /^src\/lang_fonts$/
  conf.skip_license_check << /\.mng$/ # binary
end

# load libyui-rake tasks
task_path = File.expand_path("../../tasks", __FILE__)
Dir["#{task_path}/*.rake"].each do |f|
  load f
end
