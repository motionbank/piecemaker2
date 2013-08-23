module Piecemaker
  module Helper


    module Auth
      # consider context of execution ...
      # included with 'helpers Piecemaker::Helper::Auth' in api
      # http://intridea.github.io/grape/docs/index.html#Helpers
      # 
      # example calls ...
      # 
      # authorize! :super_admin_only
      #
      # authorize! :get_events, @user_has_event_group, 
      # authorize! :get_events, @event_group
      # authorize! :get_events, @event
      # authorize! :get_events, @event_field
      def authorize!(*args)
        api_access_key = headers['X-Access-Key'] || nil
        if api_access_key
          # check if api_access_key is valid and the user is not disabled
          @user = User.first(:api_access_key => api_access_key,
            :is_disabled => false)
          unless @user
            error!('Unauthorized', 401)
          else
            # if you are a super admin, dont check any further ...
            if @user.is_super_admin
              # return @user
            end 

            # is this method for super users only?
            if args.include?(:super_admin_only) && !@user.is_super_admin
              error!('Forbidden', 403)
            end

            # check permissions ...
            args.delete :super_admin_only

            if args.count != 2
              raise ArgumentError, 
                "Expected 2 arguments: Model and Permission Entity"
            end

            entity = args[0]
            @model = args[1]

            # get user_role_id from @model
            user_role_id = nil
            if @model.is_a? "UserHasEventGroup"
              user_role_id = @model.user_role_id

            elsif @model.is_a? "EventGroup"
              @_user_has_event_group = UserHasEventGroup.first(
                :user_id => @user.id, 
                :event_group_id => @model.id)
              error!('Forbidden', 403) unless @_user_has_event_group
              user_role_id = @_user_has_event_group.user_role_id
              @_user_has_event_group = nil

            elsif @model.is_a? "Event"
              @_user_has_event_group = UserHasEventGroup.first(
                :user_id => @user.id,
                :event_group_id => @model.event_group_id)
              error!('Forbidden', 403) unless @_user_has_event_group
              user_role_id = @_user_has_event_group.user_role_id
              @_user_has_event_group = nil

            elsif @model.is_a? "EventField"
              @_event = Event.first(:id => @model.event_id)
              error!('Forbidden', 403) unless @_event

              @_user_has_event_group = UserHasEventGroup.first(
                :user_id => @user.id,
                :event_group_id => @_event.event_group_id)
              error!('Forbidden', 403) unless @_user_has_event_group
              user_role_id = @_user_has_event_group.user_role_id
              
              @_event = nil
              @_user_has_event_group = nil

            elsif @model.is_a? "UserRole"
              user_role_id = @model.id

            elsif @model.is_a? "RolePermission"
              user_role_id = @model.user_role_id

            else
              raise ArgumentError, 
                "Expected valid model as first argument"
            end
              

            @role_permission = get_permission_recursively(user_role_id, entity)
            if @role_permission.permission == "allow"
              # okay, come in!
              return user
            elsif @role_permission.permission == "forbid"
              error!('Forbidden', 403)
            else
              raise TypeError, "Unknown permission value"
            end
          
          end
        else
          error!('Bad Request, Missing X-Access-Key in Headers', 400)
        end
      end

      
      def get_permission_recursively(user_role_id, entity)
        entity = entity.to_s

        # permission defined for this role?
        @role_permission = RolePermission.first(
          :id => user_role_id, :entity => entity)

        if @role_permission
          # yes, return it
          return @role_permission
        else
          # no, look for parent user role
          @user_role = UserRole.first(:id => user_role_id)
          if @user_role.inherit_from_id
            # check, if permission is defined for parent role ...
            return get_permission_recursively(
              @user_role.inherit_from_id, entity)
          else
            # wasnt able to find permission
            return nil
          end
        end
      end

    end



    module API_Access_Key
      API_ACCESS_KEY_LENGTH = 16

      def self.generate
        chars = [('a'..'z'),('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten
        api_access_key = (0...API_ACCESS_KEY_LENGTH-5).map{ 
          chars[rand(chars.length)] }.join
        api_access_key = "0310X#{api_access_key}"
      end

      def self.makes_sense?(api_access_key)
        api_access_key.length === API_ACCESS_KEY_LENGTH &&
          api_access_key.start_with?("0310X") ? true : false
      end
    end


    module Password
      def self.generate(length)
        chars = [('a'..'z'),('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten
        (0...length).map{ chars[rand(chars.length)] }.join
      end
    end

  end
end
