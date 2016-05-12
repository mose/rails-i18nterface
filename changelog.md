Rails-i18nterface Changelog
=============================

**Warning** All Dates are GMT+8 (Asia/Taipei)

### v0.2.6 : 2016-05-12

* fix case when using rails-i18n that uses a Proc for its pluralization system (thx @bacosmin and @mutil)

### v0.2.5 : 2015-12-24

* fix sort order when ordered by text
* refactoring to make the view more viewable
* added calls to http://saucelabs.com browsers testing
* major refreshing in dependencies (2015)
* drop support for ruby 1.9 (at least for development)
* fix case when missing key is a symbol (bacosmin)
* change pattern matching to include symbol when used as translation keys

### v0.2.4 : 2013-05-07

* added an unobstrusive missing_translation enclosed in invisble chars
  for later on being able to have an in-view translation
* fix the parser of source code so it can extract the plural statements
  under the condition the `count:` param is the first one declared
  (the old way `:count =>` also is detected).
  It then generate a `.zero`, `.one` and `.other` keys
* fix the display when a translation is not a string

### v0.2.3 : 2013-05-02

* fixed default sort order to sort by key
* fix language switch and add missing test
* added a way to change single-line in multiline in translations

### v0.2.2 : 2013-04-29

* fix reload function
* some more code smell fixes

### v0.2.1 : 2013-04-27

* oy, improved code climate rating from 1.3 to 3.7, sweet (yeah I love those small badges)
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
