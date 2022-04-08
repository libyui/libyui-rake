# frozen_string_literal: true

#--
# Copyright (C) 2015-2021 SUSE LLC
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
    VERSION_CMAKE = "VERSION.cmake"
    # Targets definition
    TARGETS_FILE = File.expand_path("../../data/targets.yml", __dir__)

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
      # Returns the CMake version from the version file.
      # VERSION_TWEAK is optional.
      #
      # @param filename [String, nil] %{VERSION_CMAKE} by default
      # @return [String] like "1.2.3" or "1.2.3.4"
      def cmake_version(filename = nil)
        filename = cmake_filename(filename)

        values = cmake_values(filename,
          "VERSION_MAJOR", "VERSION_MINOR", "VERSION_PATCH", "VERSION_TWEAK")

        values.compact.join(".")
      end

      # Returns the CMake so version from the version file.
      #
      # @param filename [String, nil] %{VERSION_CMAKE} by default
      # @return [String] like "4.0.0"
      def cmake_so_version(filename = nil)
        filename = cmake_filename(filename)

        values = cmake_values(filename, "SONAME_MAJOR", "SONAME_MINOR", "SONAME_PATCH")

        values.compact.join(".")
      end

      # Bumps the so version in the CMake version file
      #
      # @param filename [string, nil] %{VERSION_CMAKE} by default
      def bump_cmake_so_version(filename = nil)
        filename = cmake_filename(filename)

        so_version = cmake_so_version(filename).split(".").first.to_i.next

        content = File.read(filename)
        content.sub!(/(^SET.*SONAME_MAJOR.*)"([^"\n])*"/, "\\1\"#{so_version}\"")
        content.sub!(/(^SET.*SONAME_MINOR.*)"([^"\n])*"/, "\\1\"0\"")
        content.sub!(/(^SET.*SONAME_PATCH.*)"([^"\n])*"/, "\\1\"0\"")

        File.write(filename, content)
      end

      # Extract values from a CMake version file
      #
      # @see cmake_value
      #
      # @param filename [String]
      # @param keys [Array<String>]
      def cmake_values(filename, *keys)
        content = File.read(filename)

        keys.map { |k| cmake_value(content, k) }
      end

      # Extracts the value of the given key from the content of a CMake version file
      #
      # @param s   [String] e.g., '... SET( VERSION_MAJOR "3") ...'
      # @param key [String] e.g., 'VERSION_MAJOR'
      #
      # @return [String] e.g., "3"
      def cmake_value(s, key)
        e_key = Regexp.escape(key)
        m = /SET\s*\(\s*#{e_key}\s+"([^"]*)"\s*\)/.match(s)
        m ? m[1] : nil
      end

      # Filename of the CMake version file
      #
      # @param filename [string, nil] %{VERSION_CMAKE} if no filename is given
      # @return [String]
      def cmake_filename(filename)
        filename || VERSION_CMAKE
      end

      # Returns the so version from the given spec file
      #
      # @param filename [String, nil] if nil, it uses the shortest spec filename
      # @return [String, nil] e.g., "12"
      def spec_so_version(filename = nil)
        filename = spec_filename(filename)

        File.read(filename).scan(/^%define\s+so_version\s+(\d+)/).flatten.first
      end

      # Bumps the so version in the given spec file
      #
      # @param filename [String, nil] if nil, it uses the shortest spec filename
      def bump_spec_so_version(filename = nil)
        filename = spec_filename(filename)

        so_version = spec_so_version(filename).to_i.next

        content = File.read(filename)
        content.gsub!(/^(%define\s+so_version\s+)\d+$/, "\\1#{so_version}")

        File.write(filename, content)
      end

      # Filename of the spec file
      #
      # @param filename [String, nil] if nil, it uses the shortest spec filename
      # @return [String]
      def spec_filename(filename)
        filename || Dir.glob("package/*.spec").min
      end
    end
  end
end
