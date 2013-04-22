class RenameTranslationToNamespace < ActiveRecord::Migration
  def self.up
    rename_table :translations, :rails_i18nterface_translations
  end
  def self.down
    rename_table :rails_i18nterface_translations, :translations
  end
end