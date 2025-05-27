source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 8.0.2'
# Use mysql as the database for Active Record
gem 'mysql2'
gem 'trilogy'
# Use Puma as the app server
gem 'puma', '~> 6.6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
# gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.13'

# CORS
gem 'rack-cors'

# CSVの読み書きに使用
gem 'csv'

# ActiveJob
gem 'solid_queue', '~> 1.1'
gem 'mission_control-jobs', '~> 1.0.2'

gem 'hiredis'
gem 'redis', '~> 5.4'
gem 'redis-namespace'

# パスワード生成
gem 'bcrypt'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# ログをJSONで記録する
gem 'lograge'

# マイグレーション管理
gem 'ridgepole', require: false

# S3制御
gem 'aws-sdk-s3'

# 管理画面構築
gem 'administrate'
gem 'administrate-field-active_storage'
gem 'clearance'
gem 'momentjs-rails'

# ジョブの次回実行時刻を得るため、永続化された書式を復元する
gem 'cronex'
gem 'fugit'

# Rails7.0でデフォルトで依存しないように変更になった。
# アプリケーション中ではsprocketsは使用していないが
# administrateで使用している、かつgemspecにsprockets-railsの記載がないため追加する
gem 'sprockets-rails'

# ActiveRecordにbe_blankな値を渡した時にNULLとする
gem 'nilify_blanks'

# アクセスコントロール
gem 'pundit'

# ULID生成
gem 'ulid'

# 認証
gem 'oauth2'
gem 'jwt'

# リクエストコンテキスト中のデータの参照を抽象化する
gem 'request_store'

# カバレッジ出力のフォーマット
gem 'command_line_reporter', require: false

# BulkInsert
gem 'activerecord-import'

# Zip
gem 'rubyzip', require: %w[zip] # gem名とファイル名が異なるため明示的にrequireする

# Excel読み書き
gem 'rubyXL', require: %w[rubyXL rubyXL/convenience_methods]
# 軽量テンプレート　-> Excelの置き換えルールに利用する
gem 'mustache'

# Pub/Sub
gem 'wisper'

# HTTPクライアント
gem 'faraday'
gem 'faraday-retry'

gem 'nkf'

# ENV['USE_FAKE_DATA'] = sandbox環境
use_fake_data = if ENV['USE_FAKE_DATA'].respond_to?(:empty?)
                  !ENV['USE_FAKE_DATA'].empty?
else
                  # rubocop:disable Style/DoubleNegation
                  # true/falseでの返却を期待するため
                  !!ENV['USE_FAKE_DATA']
  # rubocop:enable Style/DoubleNegation
end

if use_fake_data
  gem 'factory_bot_rails'
  gem 'faker'
else
  group :development, :test do
    gem 'factory_bot_rails'
    gem 'faker'
    gem 'ostruct'
  end
end

group :production do
  gem 'sentry-rails'
  gem 'sentry-ruby'
end

# rubocop:disable Bundler/DuplicatedGroup
# use_fake_data の中で宣言されているものと重複するが偽陽性
group :development, :test do
  gem 'activerecord-cause'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'gimei'
  gem 'pry-byebug'
  gem 'pry-rails'

  # コマンド実行時はRAILS_ENV指定なしなのでdevelopment
  # テスト実行時はRAILS_ENVはtest
  gem 'parallel_tests'
end
# rubocop:enable Bundler/DuplicatedGroup

group :development do
  gem 'brakeman'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'listen', '~> 3.9'
  # gem 'rack-mini-profiler', '~> 3.3'
  gem 'ruby-lsp', require: false

  gem 'annotaterb'
  gem 'i18n_generators', require: false
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rails-omakase', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'database_cleaner-active_record'
  gem 'database_cleaner-redis'

  gem 'rails-controller-testing'

  gem 'rspec-rails', require: false

  gem 'simplecov', require: false

  gem 'shoulda-matchers'

  # OpenAPI implementation check
  gem 'committee-rails'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
