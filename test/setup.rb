class User < Hanami::Entity
  attributes do
    attribute :id,                       Types::Int
    attribute :name,                     Types::String
    attribute :hashed_pass,              Types::String
    attribute :password_reset_sent_at,   Types::Time
    attribute :roles,                    Types::Array
  end
end

class Task < Hanami::Entity
  attributes do
    attribute :id,                      Types::Int
    attribute :content,                 Types::String
    attribute :author_id,               Types::Int
  end
end

module Web
  module Controllers
    class Task
      class New
        include Hanami::Action
        def controller_name
          self.class.name
        end
      end
    end
  end
end

module Web
  module Controllers
    class Task
      class Destroy
        include Hanami::Action
        def controller_name
          self.class.name
        end
      end
    end
  end
end
