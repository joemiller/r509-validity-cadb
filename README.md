r509-validity-cadb
===================

[![Build Status](https://travis-ci.org/joemiller/r509-validity-cadb.svg?branch=master)](https://travis-ci.org/joemiller/r509-validity-cadb) [![Coverage Status](https://coveralls.io/repos/joemiller/r509-validity-cadb/badge.png?branch=master)](https://coveralls.io/r/joemiller/r509-validity-cadb?branch=master)

This project is related to [r509](http://github.com/r509/r509) and
[r509-ocsp-responder](http://github.com/r509/r509-ocsp-responder) projects. It
provides certificate validity and revocation information to be read from an
OpenSSL CA DB file (sometimes 'index' file).

Because the CA DB file contains valid and revoked cert information, this allows
the responder to operate in "known good" -- responding either _VALID_,
_REVOKED_, or _UNKNOWN_ approrpriately for each serial number.

Installation
------------

First, install `r509-ocsp-responder` gem from
[r509-ocsp-responder](https://github.com/r509/r509-ocsp-responder)

Next, install via rubygems `gem install r509-validity-cadb` or if you have
cloned this repo install via `rake gem:build` and `rake gem:install`.

Usage
-----

Using the [config.ru](https://github.com/r509/r509-ocsp-responder#set-up-configru)
from r509-ocsp-responder as a baseline, remove the redis configuration and
replace with this:

```ruby
require 'r509/validity/cadb'
cadb_path = '/etc/ssl/index'

Dependo::Registry[:validity_checker] = R509::Validity::CADB::Checker.new(cadb_path)
```

The `cadb_path` variable is a path to an OpenSSL CA DB file as defined in
[OpenSSL CA DB format](http://pki-tutorial.readthedocs.org/en/latest/cadb.html).

Limitations
-----------

Only one CA DB file is supported at the moment.

Contributing
------------

1. Fork
2. Make branch
3. Add tests. `rake spec` to run test suite.
4. Send PR

Cutting a release
-----------------

1. Ensure tests passwd: `rake spec`
2. Bump version in `lib/r509/validity/cadb/version.rb`
3. Create version tag `git tag v0.0.1` (don't forget to push tag)
3. Build gem `rake gem:build`
4. Push gem to rubygems.org `rake gem push`

Author
------

Joe Miller, @miller_joe, joemiller(github)
