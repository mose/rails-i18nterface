Rails-i18nterface Changelog
=============================

**Warning** All Dates are GMT+8 (Asia/Taipei)

### v0.2.2 :



### v0.2.1 : 2013-04-27

* oy, improved code climate rating from 1.3 to 3, sweet (yeah I love those small badges)
* fix sort order on the navigation menu
* added a per_page input on view
* moved more methods from controller to libs
* added a cache (using marshall) for teh scan of translatable string extracted from application

### v0.2.0 : 2013-04-24

* added a cache lib to accelerate loading. not used yet but will be soon.
* fix on activerecords models detection, to have model names rather than table names
* removed the logs, that was useful to detect changes ubt was not refreshed
* removed the database, which was pretty useless, then no more need for migrate
* huge refactoring in the libs
* improvement on the readme

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