require 'guard'
require 'guard/guard'
require 'guard/version'
require 'rake'

module Guard
  class Rake < Guard
    def initialize(watchers=[], options={})
      super
      @options = {
        :run_on_start => true,
        :run_on_all => true,
        :run_each => true,
        :no_args => true
      }.update(options)
      @task = @options[:task]
    end

    def start
      UI.info "Starting guard-rake #{@task}"
      ::Rake.application.init
      ::Rake.application.load_rakefile
      run_across_paths(watched_files) if @options[:run_on_start]
      true
    end

    def stop
      UI.info "Stopping guard-rake #{@task}"
      true
    end

    def reload
      stop
      start
    end

    def run_all
      run_across_paths(watched_files) if @options[:run_on_all]
    end

    if ::Guard::VERSION < "1.1"
      def run_on_change(paths)
        run_across_paths(paths)
      end
    else
      def run_on_changes(paths)
        run_across_paths(paths)
      end
    end

    def watched_files
      Watcher.match_files(self, Dir.glob("**/*"))
    end

    def run_across_paths(paths)
      case
      when @options[:no_args]
        run_rake_task()
      when @options[:run_each]
        Array(paths).each do |path|
          run_rake_task(path)
        end
      else
        run_rake_task(paths)
      end
    end

    def run_rake_task(* args)
      UI.info "running #{@task}#{args.inspect}"
      ::Rake::Task.tasks.each { |t| t.reenable }
      ::Rake::Task[@task].invoke(* args)
    end
  end
end
