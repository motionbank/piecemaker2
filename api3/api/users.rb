module Piecemaker

  class Users < Grape::API

    resource 'users' do
      
      desc "Returns all users."
      get "/" do
        User.first
      end

    end
    

  end

end