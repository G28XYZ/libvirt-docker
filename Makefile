start-docker:
	make docker-compose-build

docker-compose-build:
	docker-compose -f docker-compose.yml up --build