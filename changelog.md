Rails-i18nterface Changelog
=============================

**Warning** All Dates are GMT+8 (Asia/Taipei)

### v0.1.7 : 2013-04-23

* fix the deletion of translation, it is removed from yml and display if not present in the parsed source code
* avoid saving empty translations to the yml file

### v0.1.6 : 2013-04-22

* move model into the gem namespace **warning** you gotta run `rake railties:install:migrations` and `rake db:migrate` again if you upgrade
* fix scrolling bug on the namespaces left menu
* improve style compliance with rubocop
* adding simplecov, rubocop for helping in refactoring

### v0.1.5 : 2013-04-21

* hot-bugfix

### v0.1.4 : 2013-04-21

* added experimental extraction of activerecords models and fields for the .human helpers
* cleaning up tests to make them simpler
* code cleaning: refactoring - extracting libs from controller

### v0.1.3 : 2013-04-16

* fix loading of translation:
  * if you modify the yml file it will be update the database translation automatically.
  * this was required to be able to share translation accross our development team.
* added a link to delete unused keys from database.
* changed display of files where each translation was found to be less obstrusive, and revealed on rollover only.

### v0.1.2 : 2013-04-16

* more css fixes

### v0.1.1 : 2013-04-16

* style fix on the 'Files' displayed for each translation

### v0.1.0 : 2013-04-15

* first release