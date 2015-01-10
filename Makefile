build:
	docker build -t topdeckpro_web .

push: build
	docker tag topdeckpro_web satyrius/topdeck:latest
	docker push satyrius/topdeck:latest

run:
	API_HOST=topdeck.pro ./node_modules/.bin/gulp watch
