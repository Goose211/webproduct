ActiveRecord::Base.establish_connection("sqlite3:db/development.db")

class User < ActiveRecord::Base
  has_secure_password
  has_many :quests
end

class Quest < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
end

class Category < ActiveRecord::Base
  has_many :quests
end
