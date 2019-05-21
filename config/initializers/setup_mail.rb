ActionMailer::Base.smtp_settings = {
  address:              'smtp.sendgrid.net',
  port:                 587,
  domain:               'localhost',
  user_name:            ENV['smtp_user'],
  password:             ENV['smtp_password'],
  authentication:       'plain',
  enable_starttls_auto: true  
}

ActionMailer::Base.default_url_options[:host] = ENV["hostname"]