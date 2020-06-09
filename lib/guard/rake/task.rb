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
      <% if @watch_rakefile %>
        watch(%r{^Rakefile$}) do |m|
          system("rake guard")
        end<% end %>
    end
    HEREDOC

    # A Rake task that generates Guardfile from rake tasks.
    #
    # Inside your Rakefile:
    #
    #   require "guard/rake/task"
    #
    #   Guard::Rake::Task.new
    #
    # Or, your you want to watch Rakefile as well:
    #
    #   Guard::Rake::Task.new do |t|
    #     t.watch_rakefile = true
    #   end
    #
    # You may define your own ERB template:
    #
    #    Guard::Rake::Task.new('guard') do |t|
    #      t.template=File.read('Guardfile.erb')
    #    end
    #
    # All these code will create a task that can be run with:
    #
    #   rake guard
    #
    # Examples:
    #
    #   rake guard
    #   rake guard GUARDFILE=Guardfile2.rb      # output to differente file
    #
    # @public
    #
    class Task < ::Rake::TaskLib
      # Name of task. Defaults to :guard.
      # @public
      attr_writer :name

      # Path to Guardfile.
      # Setting the GUARDFILE environment variable overrides this.
      # @public
      attr_accessor :guardfile

      # Used inside template to generate watch for Rakefile
      attr_accessor :watch_rakefile

      # The template code, default value is Guard::Rake::GUARDFILE_TEMPLATE
      attr_accessor :template

      # @public
      def initialize(name = :guard)
        @guardfile      = ENV['GUARDFILE'] || 'Guardfile'
        @name           = name
        @template       = Guard::Rake::GUARDFILE_TEMPLATE

        yield self if block_given?

        define_task
      end

      private


      def define_task
        desc "Generates a Guardfile from Rake tasks"
        task(@name) do
          all_tasks = {}
          current_task = nil
          `rake -P`.each_line do |line|
            if line.start_with? "rake" then
              current_task = line.strip
            else
              #its a dependency
              filename = line.strip
              if File.file?(filename) then
                all_tasks[current_task] = [] unless all_tasks[current_task]
                all_tasks[current_task] << filename
              end
            end
          end
          File.write(guardfile, ERB.new(@template).result(binding))
        end
      end

    end
  end
end
