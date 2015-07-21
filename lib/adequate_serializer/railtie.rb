module AdequateSerializer
  class Railtie < Rails::Railtie
    initializer 'adequate_serializer.setup_helper' do
      ActiveSupport.on_load :action_controller do
        include AdequateSerializer::Helper
      end
    end
  end
end
