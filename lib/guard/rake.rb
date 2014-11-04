require 'guard'
require 'guard/version'
require 'rake'

module Guard
  class Rake < Plugin
    class << self
      attr_accessor :rakefile_loaded
    end

    def initialize(options={})
      super
      @options = {
        :run_on_start => true,
        :run_on_all => true,
        :task_args => []
      }.update(options)
      @task = @options[:task]
    end

    def start
      UI.info "Starting guard-rake #{@task}"
      load_rakefile unless self.class.rakefile_loaded
      run_rake_task if @options[:run_on_start]
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
      run_rake_task if @options[:run_on_all]
    end

    if ::Guard::VERSION < "1.1"
      def run_on_change(paths)
        run_rake_task(paths)
      end
    else
      def run_on_modifications(paths)
        run_rake_task(paths)
      end
    end

    def run_rake_task(paths=[])
      UI.info "running #{@task}"
      ::Rake::Task.tasks.each { |t| t.reenable }
      ::Rake::Task[@task].invoke(*@options[:task_args], paths)

      Notifier.notify(
        "watched files: #{paths}",
        :title => "running rake task: #{@task}",
        :image => :success
      )
    rescue Exception => e
      UI.error "#{self.class.name} failed to run rake task <#{@task}>, exception was:\n\t#{e.class}: #{e.message}"
      UI.debug "\n#{e.backtrace.join("\n")}"

      Notifier.notify(
        " #{e.class}: #{e.message}", :title => "fail to run rake task: #{@task}", :image => :failed)
      throw :task_has_failed
    end

    def load_rakefile
      ARGV.clear
      ::Rake.application.init
      ::Rake.application.load_rakefile
      self.class.rakefile_loaded = true
    end
  end
end
