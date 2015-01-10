build:
	docker build -t topdeckpro_web .

run:
	API_HOST=topdeck.pro ./node_modules/.bin/gulp watch
