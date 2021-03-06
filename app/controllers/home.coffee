express   = require 'express'
unirest   = require 'unirest'
router    = express.Router()

nav           = 'https://api.airtable.com/v0/appVv3qQJXVr4clNx/Top Navigation Items?limit=100&view=Ktabori Navigation'
cv            = 'https://api.airtable.com/v0/appdKNFNkEK6OMU9d/Timeline Info?limit=100&view=Main View'
cv_language   = 'https://api.airtable.com/v0/appdKNFNkEK6OMU9d/Language Skills?limit=100&view=Main View'
cv_skills     = 'https://api.airtable.com/v0/appdKNFNkEK6OMU9d/Skills?limit=100&view=Main View'
api           = 'http://dash.gooose.co/api/saved/ktabori-main'

module.exports = (app) ->
  app.use '/', router

  router.get '/', (req, res, next) ->

    unirest.get nav
      .headers ({'Authorization': 'Bearer keyji9aGN0OHwZzZc'})
      .end (navres) ->

        unirest.get api
          .end (response) ->
            data = {}
            data = response.body
            data.pageTitle = 'Home'
            data.navigation = navres.body.records
            res.render 'index', data

  router.get '/cv', (req, res, next) ->

    unirest.get nav
      .headers ({'Authorization': 'Bearer keyji9aGN0OHwZzZc'})
      .end (navres) ->

        unirest.get cv_language
          .headers ({'Authorization': 'Bearer keyji9aGN0OHwZzZc'})
          .end (languages) ->

            unirest.get cv_skills
              .headers ({'Authorization': 'Bearer keyji9aGN0OHwZzZc'})
              .end (skills) ->

                unirest.get cv
                  .headers ({'Authorization': 'Bearer keyji9aGN0OHwZzZc'})
                  .end (response) ->
                    data = {}
                    data.cv = response.body.records
                    data.pageTitle = 'CV'
                    data.languages = languages.body.records
                    data.navigation = navres.body.records
                    data.skills = skills.body.records
                    #res.json data
                    res.render 'cv', data
