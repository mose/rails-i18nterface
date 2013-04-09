# RailsI18nterface 

This is a fork that has been modified to store translated messages in database and then export those into yaml file.

---

This is a Rails engine created to wrap a web interface around i18n translation files in Rails >= 3.1. 

It was originally created by [Peter Marklund and Joakim Westerlund @ mynewsdesk](https://github.com/mynewsdesk/translate) 
and later adapted to rails 3.0 by [Claudius Coenen](https://github.com/ccoenen/rails-translate). 
This version is a spinoff of Claudius Coenen's version and aims to rename, refactor and bring the functionality to rails 3.1 as an Engine. 

## Usage

In Gemfile

```ruby
gem 'rails-i18nterface'
```
In routes.rb

```ruby
mount RailsI18nterface::Engine => "/translate", :as => "translate_engine"
```

Copy migration to store translated values and migrate
```
rake railties:install:migrations
rake db:migrate
```



## License

Copyright (c) 2011 Larry Sprock and Artin Boghosain

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
