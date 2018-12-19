AML.configure do |config|
  config.mail_from = 'support@kassa.cc'
  config.card_brands = ['visa', 'master', 'mir']
  config.card_bin = { visa: 6, master: 6, mir: 4 }
  config.card_suffix = { visa: 4, master: 4, mir: 2 }
end
