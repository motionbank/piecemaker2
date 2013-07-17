module Piecemaker
  class API < Grape::API
    prefix 'api'

    format :json
    default_format :json

    version 'v1', using: :path, vendor: 'piecemaker'
    
    mount ::Piecemaker::Users
    

    if ENV['RACK_ENV'].to_sym == :development
      add_swagger_documentation api_version: 'v1'
    end
    
  end
end

