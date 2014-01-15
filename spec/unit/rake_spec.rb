require 'spec_helper'

describe "rake" do

  context "starting" do
    it "should load the rakefile" do
      expect(Guard::Rake.rakefile_loaded).to be_false

      rake = Guard::Rake.new([], :run_on_start => false)
      rake.start

      expect(Guard::Rake.rakefile_loaded).to be_true
    end
  end # starting

end
