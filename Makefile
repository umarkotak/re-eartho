run:
	bin/rails s -p 3000

push:
	git push origin master

deploy:
	ssh root@47.254.247.135 'cd projects/be/eartho && git pull --rebase origin master'

deploy-migrate:
	ssh root@47.254.247.135 'cd projects/be/eartho && rails db:migrate'

deploy-bundle:
	ssh root@47.254.247.135 'cd projects/be/eartho && bundle install'

deploy-initiator-init:
	ssh root@47.254.247.135 'cd projects/be/eartho && rake initiator:generate_initial_data'

deploy-initiator-destroy:
	ssh root@47.254.247.135 'cd projects/be/eartho && rake initiator:destroyer_run'
