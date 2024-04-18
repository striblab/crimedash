# Star Tribune Public Safety Dashboard

Welcome to the Star Tribune's Public Safety Dashboard. Use this to browse crime, policing and other public safety statistics for Minneapolis and elsewhere in Minnesota.

Dashboard URL: [https://striblab.github.io/20240428-crimedash/dist](https://striblab.github.io/20240428-crimedash/dist)

[Email](mailto:jeff.hargarten@startribune.com) or Slack any questions or issues to Jeff Hargarten.

## DISCLAIMERS

This isn't meant for external use outside the Star Tribune newsroom.

All provided statistics should be double-checked in case of data ingestion errors.


## Starting a project

To start a new project based on this template, run

```
npx degit striblab/strib-svelte-vite-template#main name-of-your-new-project
cd name-of-your-new-project
npm install
```

## Development

To run the dev server run `npm run dev`.

To build for deployment, run `npm run build`.

## Strib webfonts

The licenses for webfonts used by the Star Tribune stipulate the fonts can only be served from startribune.com
URLs, meaning they are blocked from localhost while you are developing. To get around this, run the shell script `npm run get-fonts` to download .woff font files directly to the `/public/strib-webfonts/` directory.
The local webfonts themselves and the webfont SCSS file that references them are excluded from build and deploy processes. If deployed to static.startribune.com, Star Tribune webfonts will render as they normally should without the need for local font files.


## Deploying

Deployment is currently handled by a shell script (`strib-deploy.sh`). You need to have the [AWS CLI](https://aws.amazon.com/cli/) installed
with credentials for the static.startribune.com bucket using the 'default' profile.

To deploy to staging, run `npm run deploy-staging`. For production, run `npm run deploy-production`. This will upload to a typical path using your project's name, which is read from the root directory of your project (where `package.json` is located). 



## Updating data

To update data, run each section of (`crimedash.Rmd`) in the /scripts folder. This will pull all the most recent data for the following sections: Minneapolis murders, gunfire, aggravated assaults, sex offenses, robbery, automobile theft, burglary, larceny and arson. 

Sections like police activity, police staffing, force-use, LEOKA, plus St. Paul, statewide and national crime statistics are manually updated on a less regular basis since new data isn't available as often, or special data practices requests are required to obtain new numbers.