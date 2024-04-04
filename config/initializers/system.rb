# config/initializers/system.rb
Dry::Rails.container do
  config.component_dirs.add "app/operations"
end