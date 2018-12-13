ActionMailer::Base.smtp_settings = {
  enable_starttls_auto: true,
  address: 'smtp.gmail.com',
  port: 587,
  domain: "digitalyou.es",
  authentication: :login,
  user_name: 'noreply@digitalyou.es',
  password: 'klJKHufgihbjhgF56(/&(UIgyvbb vjhlb njk6(/%%&457676'
}

ActionMailer::Base.default_url_options[:host] = Rails.env.development? ? "localhost:3000" : "appointex.es"
