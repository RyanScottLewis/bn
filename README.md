# BN

BN is a [Battle.net](http://battle.net) API adapter and entity mapper.

## Install

### Bundler: `gem "bn"`

### RubyGems: `gem install bn`

## Usage

### Requiring

You can require the whole library with

```rb
require "bn"
```

Or you can require individual files/groups of files with

```rb
require "bn/api/d3"
require "bn/entity/d3"
```

### API

**Mapping**

The `BN::API::Mapper` will send an HTTP request, parse the JSON response body, and create a new instance of
the entity associated with the API call.

```rb
require "bn/api/mapper"

mapper = BN::API::Mapper.new(key: "00000000000000000000000000000000")

p mapper.d3.profile(battle_tag: "Example#0000") #=> #<BN::Entity::D3::Profile:0x007fa2a10e29a0 @battle_tag="Example#0000" ...>
```

If called without arguments, the mapper will return a `BN::API::Mapping` instance, which associates API calls with
`Entity` instances. It also holds the list of middleware which the API HTTP response will go through before returning:

```rb
require "bn/api/mapper"

mapper = BN::API::Mapper.new(key: "00000000000000000000000000000000")
mapping = mapper.d3.profile

p mapping.api_class # => BN::API::D3
p mapping.api_method # => :profile
p mapping.middleware # => [BN::Middleware::HTTPResponse, BN::Middleware::KeyConverter, BN::Middleware::APIError, BN::Middleware::D3::Profile]

mapping.execute(battle_tag: "Example#0000") #=> #<BN::Entity::D3::Profile:0x007fa2a10e29a0 @battle_tag="Example#0000" ...>
```

This would allow you to manipulate the middleware before executing.

[Read more about middleware here.](#middleware)

**HTTP**

This simply sends an HTTP request to the API and returns it.  
Useful for when you do not need entities or middleware.

```rb
require "bn/api/d3"

api = BN::API::D3.new(key: "00000000000000000000000000000000")

p api.profile(battle_tag: "Example#0000") #=> #<HTTPI::Response:0x007fa2a0d0a5d0 @code=301 ...>
```

### Entity

An entity is a subclass of `BN::Entity::Base` for profiles, characters, items, and other game items.

You can initialize entities with an object responding to `#to_h` or use attribute setters after initialization.

```rb
require "bn/entity/d3/hero"

hero = BN::Entity::D3::Hero.new(name: "Gronc")
hero.level = 70
```

Some entities also come with some helper methods for calculations:

```rb
hero.strength = 220

# Calculate the damage per second based on hero attributes
p hero.damage # => 12345
```

### Middleware

Middleware converts data from one form to another, raising an error on failure.

For example, the `BN::Middleware::HTTPResponse` accepts anything that responds to `#body` and attempts to parse
the body as JSON. If the response body could not be parsed or the JSON API response returned an error, then an error
will be raised.

This is useful if you're not using `BN::API` to send HTTP requests to the Battle.net API.

```rb
require "net/http"
require "uri"
require "bn/middleware/http_response"

uri = URI("https://us.api.battle.net/d3/profile/Example-0000")
uri.query = URI.encode_www_form(apikey: "00000000000000000000000000000000", locale: "en_US")
response = Net::HTTP.get_response(uri)

data = BN::Middleware::HTTPResponse.execute(response)

p data # => { battle_tag: "Example#0000" }
```

**Chaining**

Middleware can be chained together if the result of one conforms to the requirements of another:

```rb
require "bn/api/d3"
require "bn/middleware/http_response"
require "bn/middleware/d3/profile"

api = BN::API::D3.new(key: "00000000000000000000000000000000")

response = api.profile(battle_tag: "Example#0000")

data = BN::Middleware::HTTPResponse.execute(response)
profile = BN::Middleware::D3::Profile.execute(data)

p profile #=> #<BN::Entity::D3::Profile:0x007fa2a10e29a0 @battle_tag="Example#0000" ...>
```

To make chaining easier, there is a helper method on `BN::Middleware`:

```rb
require "bn/api/d3"
require "bn/middleware"

api = BN::API::D3.new(key: "00000000000000000000000000000000")

response = api.profile(battle_tag: "Example#0000")

profile = BN::Middleware.execute(data, BN::Middleware::HTTPResponse, BN::Middleware::D3::Profile)

p profile #=> #<BN::Entity::D3::Profile:0x007fa2a10e29a0 @battle_tag="Example#0000" ...>
```

Middleware given can either be classes or instances. Usually subclassed from `BN::Middleware::Base`, but can be anything
responding to `#execute`.

**Subclassing**

You can subclass `BN::Middleware::Base` to create your own transformations, such as manipulating JSON API responses
or initializing your own profile/item/etc objects:

```rb
require "bn/middleware/base"

class HeroMiddleware < BN::Middleware::Base
  def execute(data)
    hero_data = data[:heroes].first

    Hero.new(data[:hero_data])
  end
end

class Hero
  def initialize(name)
    @name = name
  end

  attr_reader :name
end

require "bn/api/d3"
require "bn/middleware/http_response"

api = BN::API::D3.new(key: "00000000000000000000000000000000")

response = api.hero(battle_tag: "Example#0000", id: 1234)

data = BN::Transform::HTTPResponse.execute(response)
hero = HeroTransform.execute(data)

p hero #=> #<Hero:0x007fa2a10e29a0 @name="Gronc">
```

## Copyright

Copyright © 2015 Ryan Scott Lewis <ryan@rynet.us>.

The MIT License (MIT) - See LICENSE for further details.
