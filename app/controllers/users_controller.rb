class UsersController < ApplicationController

  after_action :after_action

  def show
    render json: User.find(params[:id]), include: 'organizations'
  end

  def after_action
    Rails.logger.debug do
      {
        ams_config: {
          cache_store: ActiveModelSerializers.config.cache_store.present?,
          perform_caching: ActiveModelSerializers.config.perform_caching
        },
        serializers_config: {
          UserSerializer_caching: UserSerializer._cache.present?
        },
        app_config: {
          cache_store: Rails.configuration.cache_store.present?,
          perform_caching: Rails.configuration.action_controller.perform_caching
        }
      }.to_json
    end
  end

end
