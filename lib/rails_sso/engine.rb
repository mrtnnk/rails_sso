module RailsSso
  class Engine < Rails::Engine
    initializer 'sso.helpers' do
      ActiveSupport.on_load(:action_controller) do
        include RailsSso::Helpers
      end
    end

    initializer 'sso.omniauth', after: :load_config_initializers, before: :build_middleware_stack do |app|
      if RailsSso.provider_name
        RailsSso.oauth2_strategy_class.class_eval do
          def setup_phase
            setup_sso!

            super
          end

          def other_phase
            setup_sso!

            call_app!
          end

          def setup_sso!
            env['sso'] ||= RailsSso::App.new(self, session)
          end
        end

        app.config.middleware.use OmniAuth::Builder do
          provider RailsSso.provider_name,
            RailsSso.provider_key,
            RailsSso.provider_secret,
            callback_path: RailsSso.provider_callback_path
        end

        app.config.middleware.insert_after OmniAuth::Builder, Warden::Manager do |manager|
          manager.default_strategies :sso
          manager.failure_app = RailsSso::FailureApp
        end
      end
    end
  end
end
