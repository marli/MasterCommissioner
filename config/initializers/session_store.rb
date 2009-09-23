# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_MasterCommissioner_session',
  :secret      => '5bfd92437bfe402824745ca324297b9af80017248f35b13dbb24e1d685ae098a94eafb7175efbd3092c129fba644fca139afc6fcbba5eb4767ff418a98467a48'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
