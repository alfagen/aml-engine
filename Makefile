all: setup tests rubocop

rails_env:
	bin/rails db:environment:set RAILS_ENV=test || echo 'Провалилось environment:set'
	env | grep PATH
	env | grep RAILS || (echo "!!! Установите RAILS_ENV=test" && /bin/false)

setup: rails_env

tests:
	bundle exec rake db:drop || echo 'db does not exists'
	bundle exec rake db:create db:schema:load
	bundle exec rspec

rubocop:
	bundle exec rubocop -R
