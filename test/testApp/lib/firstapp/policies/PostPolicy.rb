    module Firstapp
      class PostPolicy
        def initialize(roles)
          @user_roles = roles
          # Uncomment the required roles and add the
          # appropriate user role to the @authorized_roles* array.
          # @authorized_roles_for_new = []
          # @authorized_roles_for_create = []
          # @authorized_roles_for_show = []
          # @authorized_roles_for_index = []
          # @authorized_roles_for_edit = []
          # @authorized_roles_for_update = []
          # @authorized_roles_for_destroy = []
        end

        def new?
          (@authorized_roles_for_new & @user_roles).any?
        end

        def create?
          (@authorized_roles_for_create & @user_roles).any?
        end

        def show?
          (@authorized_roles_for_show & @user_roles).any?
        end

        def index?
          (@authorized_roles_for_index & @user_roles).any?
        end

        def edit?
          (@authorized_roles_for_edit & @user_roles).any?
        end

        def update?
          (@authorized_roles_for_update & @user_roles).any?
        end

        def destroy?
          (@authorized_roles_for_destroy & @user_roles).any?
        end
      end
    end
