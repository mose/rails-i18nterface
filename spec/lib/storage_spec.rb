require 'spec_helper'

describe RailsI18nterface::Storage do
  describe "write_to_file" do
    before(:each) do
      @storage = RailsI18nterface::Storage.new(:en)
    end
  
    it "writes all I18n messages for a locale to YAML file" do
      I18n.backend.should_receive(:translations).and_return(translations)
      @storage.stub!(:file_path).and_return(file_path)
      file = mock(:file)
      file.should_receive(:write).with(translations)
      RailsI18nterface::File.should_receive(:new).with(file_path).and_return(file)
      @storage.write_to_file
    end
  
    def file_path
      File.join(File.dirname(__FILE__), "files", "en.yml")
    end
    
    def translations
      {
        :en => {
          :article => {
            :title => "One Article"
          },
          :category => "Category"
        }
      }
    end
  end
end
