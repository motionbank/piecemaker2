module Piecemaker

  class System < Grape::API

    #===========================================================================
    resource 'system' do #======================================================
    #===========================================================================


      #_________________________________________________________________________
      ##########################################################################
      desc "get unix timestamp with milliseconds"
      #-------------------------------------------------------------------------
      get "/utc_timestamp" do  #/api/v1/system/utc_timestamp
      #-------------------------------------------------------------------------
       # @todo
       
      end

    end

  end
end