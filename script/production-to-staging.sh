heroku maintenance:on -a bookplanner-sandbox
heroku ps:scale worker=0 -a bookplanner-sandbox
heroku pgbackups:transfer bookplanner::CYAN HEROKU_POSTGRESQL_GRAY -a bookplanner-sandbox
heroku pg:promote HEROKU_POSTGRESQL_GRAY -a bookplanner-sandbox
heroku ps:scale worker=1 -a bookplanner-sandbox
heroku maintenance:off -a bookplanner-sandbox
