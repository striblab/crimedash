# Star Tribune Public Safety Dashboard

Welcome to the Star Tribune Public Safety Dashboard. Use this to browse crime, policing and other public safety statistics for Minneapolis and elsewhere in Minnesota.

Dashboard URL: [https://striblab.github.io/crimedash/dist](https://striblab.github.io/crimedash/dist)

[Email](mailto:jeff.hargarten@startribune.com) or Slack any questions or issues to Jeff Hargarten.

## DISCLAIMER

This isn't meant for external use outside the Star Tribune newsroom. All provided statistics should be double-checked in case of data ingestion errors.


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


## Updating data

To update data, run each section of (`crimedash.Rmd`) in the /scripts folder. This will pull all the most recent data for most sections, with raw data living in the /store folder on Github.

Sections like police activity, police staffing, force-use, LEOKA, plus St. Paul, statewide and national crime statistics are manually updated on a less regular basis since new data isn't available as often, or special data practices requests are required to obtain new numbers.


## Deploying

This is hosted off Github Pages, so all updates committed to this Github repo will automagically update the live page with new data and any other changes.