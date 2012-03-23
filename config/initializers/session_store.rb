# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_SocialAlarms2_session',
  :secret      => '1f20af15fddf0b585af83f4008de842749977ac1b510f9bb758f6466b44e5760212edc6c4933d312b1c7c1a1746509007a372efacfa9a75bdf92a75bb440ac28'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
