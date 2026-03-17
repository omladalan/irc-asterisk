IMAGE_NAME?=omladalan/irc-asterisk
IMAGE_VERSION?=latest

makemenu-up:
	docker compose -f docker-compose-makemenu.yml up -d irc-asterisk-makemenu --build
	#docker exec -it irc-asterisk-makemenu bash
	#navagate to /usr/src/asterisk-certified-22.8-cert1 and run: make menuselect
	#AFTER SELECT and save exit of container shell: exit
copy-makemenu2host:
	docker cp irc-asterisk-makemenu:/usr/src/asterisk-certified-22.8-cert1/menuselect.makeopts ./menuselect.makeopts
	docker compose -f docker-compose-makemenu.yml down


docker-x86:
	docker build \
		-t $(IMAGE_NAME):$(IMAGE_VERSION) \
		-f ./Dockerfile \
		.

push: 
	docker push $(IMAGE_NAME):$(IMAGE_VERSION)