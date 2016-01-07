express   = require 'express'
unirest   = require 'unirest'
router    = express.Router()

nav           = 'https://api.fieldbook.com/v1/56735a3183ee3c03004e88b0/main_navigation'
cv            = 'https://api.fieldbook.com/v1/56735a3183ee3c03004e88b0/cv'
cv_language   = 'https://api.fieldbook.com/v1/56735a3183ee3c03004e88b0/cv_language_skills'
cv_skills     = 'https://api.fieldbook.com/v1/56735a3183ee3c03004e88b0/cv_skills'
api           = 'http://cms.dmngd.co/api/merged/88bc4efed93e452d1cbb4f1aad672f24/rendered'

module.exports = (app) ->
  app.use '/', router

  router.get '/', (req, res, next) ->

    unirest.get nav
      .end (navres) ->

        unirest.get api
          .end (response) ->
            data = response.body
            data.pageTitle = 'Home'
            data.navigation = navres.body
            console.log data.data
            res.render 'index', data

  router.get '/cv', (req, res, next) ->

    unirest.get nav
      .end (navres) ->

        unirest.get cv_language
          .end (languages) ->

            unirest.get cv_skills
              .end (skills) ->

                unirest.get cv
                  .end (response) ->
                    data = {}
                    data.cv = response.body
                    data.pageTitle = 'CV'
                    data.languages = languages.body
                    data.navigation = navres.body
                    data.skills = skills.body
                    res.render 'cv', data
