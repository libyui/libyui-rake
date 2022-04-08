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

Gem::Specification.new do |spec|
  # gem name and description
  spec.name	= "libyui-rake"
  spec.version	= File.read(File.expand_path("VERSION", __dir__)).chomp
  spec.summary	= "Rake tasks that provide basic workflow for libyui development"
  spec.license = "LGPL-2.1"

  # author
  spec.author	= "YaST team"
  spec.email	= "yast-devel@lists.opensuse.org"
  spec.homepage	= "https://github.com/libyui/libyui-rake"

  spec.description = <<~DESCRIPTION
    Rake tasks that support the workflow of a libyui developer. It allows packaging
    a repo, sending it to the build service, creating a submit request to the
    target repo or running the client from the git repo.
    Heavily inspired by yast-rake.
  DESCRIPTION

  # gem content
  spec.files = Dir["lib/**/*.rb", "lib/tasks/*.rake", "data/*", "COPYING", "README.md", "VERSION"]

  # define LOAD_PATH
  spec.require_path = "lib"

  # Ruby 2.5.0+ is required
  spec.required_ruby_version = ">= 2.5.0"

  # dependencies
  # "~> 1.5"  means ">= 1.5 and < 2" (thanks to darix)
  spec.add_runtime_dependency("packaging_rake_tasks", "~> 1.5")
  spec.add_runtime_dependency("rake", "> 10.0", "< 99")
  spec.metadata["rubygems_mfa_required"] = "true"
end
