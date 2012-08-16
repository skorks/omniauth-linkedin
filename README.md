# OmniAuth LinkedIn

This gem contains the LinkedIn strategy for OmniAuth 1.0 .

LinkedIn uses the OAuth 1.0a flow, you can read about it here: https://developer.linkedin.com/documents/authentication

## How To Use It

Usage is as per any other OmniAuth 1.0 strategy. So let's say you're using Rails, you need to add the strategy to your `Gemfile` along side omniauth:

    gem 'omniauth'
    gem 'omniauth-linkedin'

Once these are in, you need to add the following to your `config/initializers/omniauth.rb`:

    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :linkedin, "consumer_key", "consumer_secret"
    end

You will obviously have to put in your key and secret, which you get when you register your app with LinkedIn (they call them API Key and Secret Key).

Now just follow the README at: https://github.com/intridea/omniauth

## Additional permissions

LinkedIn recently (August 2012) provided the ability to request different permissions by specifying a scope. You can find more information on the different permissions at https://developer.linkedin.com/documents/authentication

By default, omniauth-linkedin requests the following permissions:

    "r_basicprofile r_emailaddress"

This allows us to obtain enough information from LinkedIn to satisfy the requirements for the basic auth hash schema.

To change the scope, simply change your initializer to something like this:

    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :linkedin, "consumer_key", "consumer_secret", :scope => 'r_fullprofile r_emailaddress r_network'
    end

One thing to note is the fact that when you ask for extra permissions, you will probably want to specify the array of fields that you want returned in the omniauth hash. If you don't then only the default fields (see below) will be returned which would defeat the purpose of asking for the extra permissions. So do the following:

    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :linkedin, "consumer_key", "consumer_secret", :scope => 'r_fullprofile r_emailaddress r_network', :fields => ["id", "email-address", "first-name", "last-name", "headline", "industry", "picture-url", "public-profile-url", "location", "connections"]
    end

We have to repeat the list of default fields in order to get the extra 'connections' field.

The list of default fields is as follows:

    ["id", "email-address", "first-name", "last-name", "headline", "industry", "picture-url", "public-profile-url", "location"]

To see a complete list of available fields, consult the LinkedIn documentation at https://developer.linkedin.com/documents/profile-fields

## Using It With The LinkedIn Gem

You may find that you want to use OmniAuth for authentication, but you want to use an API wrapper such as this one https://github.com/pengwynn/linkedin to actually make your api calls. But the LinkedIn gem provides it's own way to authenticate with LinkedIn via OAuth. In this case you can do the following.

Configure the LinkedIn gem with your consumer key and secret:

    LinkedIn.configure do |config|
      config.token = "consumer_key"
      config.secret = "consumer_secret"
    end

Use OmniAuth as per normal to obtain an access token and an access token secret for your user. Now create the LinkedIn client and authorize it using the access token and secret that you ontained via OmniAuth:

    client = LinkedIn::Client.new
    client.authorize_from_access("access_token", "access_token_secret")

You can now make API calls as per normal e.g.:

    client.profile
    client.add_share({:comment => "blah"})

## Note on Patches/Pull Requests

- Fork the project.
- Make your feature addition or bug fix.
- Add tests for it. This is important so I don’t break it in a future version unintentionally.
- Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
- Send me a pull request. Bonus points for topic branches.

## License

Copyright (c) 2011 by Alan Skorkin

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
