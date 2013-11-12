OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1419194284976996', 'd6c992c26d4f572d41d9dea37ada3725'
end