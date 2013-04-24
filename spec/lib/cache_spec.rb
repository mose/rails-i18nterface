require 'spec_helper'

describe RailsI18nterface::Cache do
  include RailsI18nterface::Cache

  before :each do
    @tmpfile = File.expand_path(File.join('..','files','cache_test',__FILE__))
    FileUtils.rm @tmpfile
  end

  it 'stores cache of an object' do

  end

end