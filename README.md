# AdequateSerializer

[![Gem Version][vb]][vl] [![Build Status][tb]][tl] [![Code Climate][cb]][cl]

A very opinionated lightweight serializer.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'adequate_serializer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install adequate_serializer

## Usage

### Controller

Just use AdequateSerializer's `serialize` method to serialize your data.
It doesn't matter whether it is just one object or a collection.

```ruby
class UsersController < ApplicationController
  def index
    @users = User.all
    render json: serialize(@users)
  end

  def show
    @user = User.find(params[:id])
    render json: serialize(@user)
  end
end
```

The serialize method will infer the serializer's name from the class of the
object it serializes. In this case it will look for a `UserSerializer`.

If you want another serializer, you can just pass it to the `serialize`
method.

```ruby
render json: serialize(@user, serializer: AdminSerializer)
```

### Root Key

By default the `serialize` method will infer the root key from the objects it
is serializing. For example, when you give it a user the root will be `user`
or rather `users` if you provide a collection of users.

You can also define the root key yourself:

```ruby
serialize(@user, root: :admin)
```

or use no root at all:

```ruby
serialize(@user, root: false)
```

It works with a ActiveRecord::Relation or an array. However, if you could end
up serializing an empty array, you should define a root yourself. Otherwise it
cannot infer the root key and you will end up with a `nil` key. This
isn't needed for ActiveRecord::Relations.

### Attributes

You can specify which attributes of your objects will be serialized in the
serializer.

```ruby
class UserSerializer::Base
  attributes :id, :full_name, :created_at, :updated_at

  def full_name
    "#{object.first_name} #{object.last_name}"
  end
end
```

These can be attributes or methods of your model. You can also define methods
in the serializer itself and use them.

Within a serializer's methods, you can access the object being serialized as
`object`.

### Associations

If you want to include associations, just specify them in the controller.

```ruby
serialize(@user, includes: :posts)
```

In this case the PostSerializer will be used to nest the user's posts under the
`posts` key in the user JSON object.

You can also include multiple associations by using an array of association
keys.

#### Overriding association methods

If you want to override any association, you can use:

```ruby
class UserSerializer::Base
  attributes :id, :created_at, :updated_at

  def posts
    object.posts.published
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake test` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`,
and then run `bundle exec rake release`, which will create a git tag for the
version, push git commits and tags, and push the `.gem` file to
[rubygems.org][rg].

## Contributing

Bug reports and pull requests are welcome on [GitHub][gh]. This project is
intended to be a safe, welcoming space for collaboration, and contributors
are expected to adhere to the [Contributor Covenant][cc] code of conduct.

## Credits

![netflower][nl]

AdequateSerializer is maintained by [netflower Ltd. & Co. KG][n].

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[vb]: https://badge.fury.io/rb/adequate_serializer.svg
[vl]: http://badge.fury.io/rb/adequate_serializer
[tb]: https://travis-ci.org/netflower/adequate_serializer.svg?branch=master
[tl]: https://travis-ci.org/netflower/adequate_serializer
[cb]: https://codeclimate.com/github/netflower/adequate_serializer/badges/gpa.svg
[cl]: https://codeclimate.com/github/netflower/adequate_serializer
[rg]: https://rubygems.org
[gh]: https://github.com/netflower/adequate_serializer
[cc]: contributor-covenant.org
[n]: http://netflower.de
[nl]: https://cloud.githubusercontent.com/assets/464565/5997997/91da2232-aac2-11e4-9278-fdf21fb8a6e9.png
