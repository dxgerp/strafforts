source 'https://rubygems.org'
ruby ENV['CUSTOM_RUBY_VERSION'] || '2.5.3'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.12'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'phantomjs', :require => 'phantomjs/poltergeist' unless Gem.win_platform?
  gem 'poltergeist'
  gem 'rspec'
  gem 'rspec-rails'
  gem "factory_bot_rails", "~> 4.0"
  gem "faker"
  gem 'bullet' # Help to kill N+1 queries and unused eager loading.
  gem 'fuubar' # The instafailing RSpec progress bar formatter.
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'dotenv-rails'

  gem 'mdl', require: false # Markdown lint tool.
  gem 'os', '~> 1.0'
  gem 'rubocop', require: false
  gem 'wdm', '>= 0.1.0' if Gem.win_platform? # Require wdm for Windows.
  gem 'solargraph', require: false

  gem 'annotate' # Annotate Rails classes with schema and routes info.
end

group :test do
  gem 'codecov', require: false # Code coverage tool.
  gem 'simplecov', :require => false # Code coverage tool.

  gem 'shoulda', '~> 3.5'
  gem 'shoulda-matchers', '~> 2.0'
  gem 'webmock'
  gem 'rspec-sidekiq'
end

group :production do
  gem 'heroku-deflater' # Enable gzip compression on heroku, but don't compress images.
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 3.5'

# Use Draper to add an object-oriented layer of presentation logic.
gem 'activemodel-serializers-xml', github: 'rails/activemodel-serializers-xml'
gem 'draper'

gem 'foreman' # Manager Procfile.dev under development environment.
gem 'bootstrap-sass', '~> 3.3.6' # Bootstrap.
gem 'config' # Config.
gem 'font-awesome-rails' # Rails Font Awesome.

gem 'mailerlite' # Mailer Lite API wrapper.
gem 'strava-api-v3' # Strava Ruby API Client.
gem 'stripe' # Ruby library for the Stripe API.

gem 'sidekiq'
