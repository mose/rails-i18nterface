module RailsI18nterface
  class Engine < Rails::Engine
    isolate_namespace RailsI18nterface
    puts paths.inspect
  end
end
