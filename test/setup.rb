class User
  attr_accessor :id, :name, :hashed_pass, :password_reset_sent_at, :roles

  def initialize(attributes = {})
    @id = attributes[:id]
    @name = attributes[:name]
    @hashed_pass = attributes[:hashed_pass]
    @password_reset_sent_at = attributes[:password_reset_sent_at]
    @roles = attributes[:roles]
  end
end

class Task
  attr_accessor :id, :content, :author_id
  
  def initialize(attributes = {})
    @id = attributes[:id]
    @content = attributes[:content]
    @author_id = attributes[:author_id]
  end
end

module Testapp
  module Actions
    class Tasks
      
      class New
        include Hanami::Rokku

        def action_name
          self.class.name
        end
      end

      class Destroy
        include Hanami::Rokku

        def action_name
          self.class.name
        end
      end
    end
  end
end

module Admin
  module Actions
    class Tasks
      class New
        include Hanami::Rokku

        def action_name
          self.class.name
        end
      end
    end
  end
end
