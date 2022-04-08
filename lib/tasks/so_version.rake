# frozen_string_literal: true

#--
# Copyright (C) 2021 SUSE LLC
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

namespace :so_version do
  include Libyui::Tasks::Helpers

  desc "Check that the so version numbers are in sync"
  task :check do
    so_version = cmake_so_version.split(".").first

    filenames = Dir.glob("package/*.spec").sort
    filenames.reject! { |f| spec_so_version(f).nil? }

    mismatches = filenames.reject { |f| spec_so_version(f) == so_version }

    if mismatches.any?
      messages = ["so version mismatch:"]
      messages << "cmake so version: #{so_version}"
      messages += mismatches.map { |f| "#{f}: #{spec_so_version(f)}" }

      raise messages.join("\n")
    end

    puts cmake_so_version if verbose
  end

  desc "Increase the so version in spec and cmake files"
  task bump: :check do
    bump_cmake_so_version

    Dir.glob("package/*.spec").each { |f| bump_spec_so_version(f) }

    puts cmake_so_version if verbose
  end

  desc "Show the so version"
  task :show do
    puts cmake_so_version
  end
end
