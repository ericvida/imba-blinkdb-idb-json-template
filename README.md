_Bootstrapped with [imba-base-template](https://github.com/imba/imba-base-template)._

# Imba + BlinkDB
An [Imba](https://imba.io) starter template with [BlinkDB](https://blinkdb.io/) for blazing fast client-side data, and json file persistence

![CleanShot 2023-11-29 at 17 00 40@2x](https://github.com/ericvida/imba-blinkdb-json-template/assets/13579055/37dad601-3210-43a6-8b42-322d004fa4fb)

It's perfect for creating offline data json data management apps.
Or for quickly building client-side app.

## To use

Change directory to your desired directory for your new project.
### `cd ./Desktop/`

clone repo
### `git clone https://github.com/ericvida/imba-blinkdb-json-template.git imba-blinkdb-json`

## Install Dependencies

### `npm install`

You may replace `imba-blinkdb-json` for any folder name you'd like.

## Available Scripts

In the project directory, you can run:

### `npm dev`

Runs the server and website in the development mode with hot reloading, linting and detailed error output in the console, and source maps.

Open [http://localhost:3000](http://localhost:3000) to view it in the browser. When you change your code, it will live reload.

### `npm run build`

Builds the app for production to the `dist` folder.

### `npm run start`

Quickly fire up the website in production mode through NPM, like `npm run dev` but without any development settings. Will also run on [http://localhost:3000](http://localhost:3000), and can be a quick way to get started with running this site on your server.

However, [to run Imba in production](https://imba.io/guide/run-in-production) it is recommended to use [PM2](https://github.com/Unitech/pm2) to manage the Node process(es).
