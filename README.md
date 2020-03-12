# Rails I18nterface

[![Gem Version](http://img.shields.io/gem/v/rails-i18nterface.svg)](https://rubygems.org/gems/rails-i18nterface)
[![Downloads](http://img.shields.io/gem/dt/rails-i18nterface.svg)](https://rubygems.org/gems/rails-i18nterface)
[![Build Status](http://img.shields.io/travis/mose/rails-i18nterface.svg)](http://travis-ci.org/mose/rails-i18nterface)
[![Code Coverage](http://img.shields.io/coveralls/mose/rails-i18nterface.svg)](https://coveralls.io/r/mose/rails-i18nterface)

![rails-i18nterface](http://mose.fr/rails-i18nterface.png)

## Usage

In Gemfile

```ruby
gem 'rails-i18nterface'
```
In routes.rb

```ruby
mount RailsI18nterface::Engine => "/translate", :as => "translate_engine"
```

### Protect access

You may want to protect the translation engine to admin and create a constraint
in your routes (note that you don't want to mount it when you launch tests):
```ruby
constraints AdminConstraint.new do
  unless Rails.env.test?
    mount RailsI18nterface::Engine => "/translate", :as => "translate_engine"
  end
end
# this second route will be then used if the user is not an admin
get 'translate', to: redirect do |p, req|
  req.flash['error'] = I18n.t('errors.permission_denied')
  "/signin"
end
```

Then create a `config/initializers/admin_constraint.rb` containing:
```ruby
class AdminConstraint
  def matches?(request)
    current_user && current_user.is_admin?
  end
end
```
(this example is for devise users, but you can adjust it to return true or false
according to your own context).

### Configuration

You can configure `from_locales` and `to_locales` explicitly in your
`environments/development.rb` by adding
```ruby
config.from_locales = [:en]
config.to_locales = [:ja, :es, :fr]
```
Where `[:en]` and `[:ja, :es, :fr]` could be replaced by locale list of your choice.

## Todo

* <s>fix the code smell reported by code climate</s> (done)
  * <s>extract code from the controller to a lib</s> (done)
  * <s>refactor the libs in a cleaner way</s> (done)
  * <s>apply rubocop and follow his law</s> (done)
* <s>remove those damn global variables</s> (done)
* <s>extend testing to refactored libs</s> (done)
* add a way in the config to ignore some gem locales
* make the application thread-safe
* change navigation to an ajax-driven reload
* add a way to gather .one and .other and .few under same translation line (not sure actually)
* add support for other i18n backends (gettext)

## Note for upgrade 0.1.x to 0.2.x

The database is not used anymore, back to the good old way.
So you can remove the table rails_i18nterface_translations (v0.1.7)
or translations (< 0.1.7).

## Project history

This is a fork of an overhaul of a fork of a fork of rails-translate.

It was originally created by [Peter Marklund and Joakim Westerlund @ mynewsdesk](https://github.com/mynewsdesk/translate)
and later adapted to rails 3.0 by [Claudius Coenen](https://github.com/ccoenen/rails-translate).
This version is a spin-off of Claudius Coenen's version by [Larry Sprock](https://github.com/lardawge/rails-i18nterface).
It was renamed, refactored and prepared for rails 3.1 as an Engine. Over this work
[Michal Hantl](https://github.com/hakunin/rails-i18nterface) made a bunch of nice UI modifications
on his fork. Since then it was more or less abandoned.

I took over the evolution with some new features:

* testing using [combustion](https://github.com/pat/combustion) and [rspec](https://github.com/rspec/rspec)
* redesign of the layout
* navigation overhaul, splitting the name-spaces in a foldable menu
* gathering of first-level translations under a ROOT container
* gemification and release of a version 0.1.0
* (the 0.0.1 was the work from Larry Sprock but was not published as a gem)
* compatibility with rails 4 and ruby 2

Check the [Changelog](https://github.com/mose/rails-i18nterface/blob/master/changelog.md) for details about further changes.

## License

```
Copyright 2009-2011 Peter Marklund, Joakim Westerlund, Claudius Coenen
Copyright 2011-2013 Larry Sprock, Artin Boghosain, Michal Hantl
Copyright 2013-2016 Mose

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
