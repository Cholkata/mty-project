# production.rb
Rails.application.configure do
  # This points to /rails/log/production.log inside the container
  log_path = Rails.root.join("log", "production.log")

  FileUtils.mkdir_p(File.dirname(log_path))

  logger = ActiveSupport::Logger.new(log_path)
  # ... rest of your config
end
