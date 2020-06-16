guard :shell do
  
    watch(%r{^(Rakefile|lib/guard/rake/task.rb)$}) do |m|
      system("rake guard")
    end
  
end
