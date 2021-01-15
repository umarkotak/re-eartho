run:
	bin/rails s -p 3000

push:
	git push origin master

deploy:
	ssh root@47.254.247.135 'cd projects/be/eartho && git pull --rebase origin master'