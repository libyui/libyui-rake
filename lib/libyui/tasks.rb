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
require "yaml"

module Libyui
  # Facilities to write Libyui related rake tasks.
  module Tasks
    # Name of the CMake version file
    VERSION_CMAKE = "VERSION.cmake".freeze
    # Targets definition
    TARGETS_FILE = File.expand_path("../../../data/targets.yml", __FILE__)

    # Wrapper to set up packaging tasks
    def self.configuration(&block)
      ::Packaging.configuration(&block)
    end

    def self.submit_to(target, file = TARGETS_FILE)
      targets = YAML.load_file(file)
      config = targets[target]
      raise "Not configuration found for #{target}" if config.nil?
      Libyui::Tasks.configuration do |conf|
        config.each do |meth, val|
          conf.public_send("#{meth}=", val)
        end
      end
    end

    # Some helpers to be used on tasks definition
    module Helpers
      # Read the version from spec file
      # @return [String] like "1.2.3"
      def spec_version(spec_filename)
        File.read(spec_filename)[/^Version:\s*(\S+)/, 1]
      end

      # Extracts the value from a CMake string
      #
      # @param s   [String] '... SET( VERSION_MAJOR "3") ...'
      # @param key [String] 'VERSION_MAJOR'
      # @return "3"
      def cmake_value(s, key)
        e_key = Regexp.escape(key)
        m = /SET\s*\(\s*#{e_key}\s+"([^"]*)"\s*\)/.match(s)
        m[1]
      end

      # Returns the CMake version from version file
      #
      # @param  [String] Version file (VERSION_CMAKE by default)
      # @return [String] like "1.2.3"
      # @see VERSION_CMAKE
      def cmake_version(file = nil)
        f = File.read(file || VERSION_CMAKE)
        [cmake_value(f, "VERSION_MAJOR"),
         cmake_value(f, "VERSION_MINOR"),
         cmake_value(f, "VERSION_PATCH")].join(".")
      end
    end
  end
end
