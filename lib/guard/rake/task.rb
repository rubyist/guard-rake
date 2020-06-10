# frozen_string_literal: true

require 'rake'
require 'rake/tasklib'
require 'rake/application'
require 'erb'

# This file was inspired by https://github.com/troessner/reek/blob/master/lib/reek/rake/task.rb
module Guard
  #
  # Defines a task library for running Guard-Rake.
  #
  # @public
  module Rake

    GUARDFILE_TEMPLATE = <<~HEREDOC
    guard :shell do
      <% all_tasks.each do |t, files| %>
        watch(%r{^(<%= files.join('|') %>)$}) do |m|
          system("rake <%= t %>")
        end
      <% end %>
    end
    HEREDOC

    class Task < ::Rake::TaskLib

      # Name of task. Defaults to :guard.
      # @public
      attr_writer :name

      # The template code, default value is Guard::Rake::GUARDFILE_TEMPLATE
      attr_accessor :template

      attr_accessor :guardfile

      # @public
      def initialize(name = 'guard', guardfile='Guardfile')
        @name           = name
        @template       = Guard::Rake::GUARDFILE_TEMPLATE
        @guardfile      = guardfile

        yield self if block_given?

        define_task
      end

      private

      def define_task
        desc "Create Guardfile from rake tasks."
        task(@name) do
          all_tasks = {}
          current_task = nil
          `rake -P`.each_line do |line|
            if line.start_with? "rake" then
              current_task = line[5..-1].strip
            else
              #its a dependency
              filename = line.strip
              if File.file?(filename) then
                all_tasks[current_task] = [] unless all_tasks[current_task]
                all_tasks[current_task] << filename
              end
            end
          end
          File.write(@guardfile, ERB.new(@template).result(binding))
        end
      end
    end
  end
end
