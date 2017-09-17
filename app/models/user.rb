class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships
  
  def full_name
    return "#{first_name} #{last_name}".strip if (first_name || last_name)
    "Anonymous"
  end
  
  def not_friends_with?(friend_id)
    friendships.where(friend_id: friend_id).count < 1
  end
  
  def except_current_user(users)
    users.reject { |user| user.id == self.id }
  end
  
  # in users_controller.rb = def search @users = User.search(params[:search_params])
  def self.search(param)
    return User.none if param.blank?
    
    param.strip!
    param.downcase!
    (first_name_matches(param) + last_name_macthes(param) + email_matches(param)).uniq
  end
  
  def self.first_name_matches(param)
    matches('first_name', param)
  end
  
  def self.last_name_matches(param)
    matches('last_name', param)
  end
  
  def self.email_matches(param)
    matches('email', param)    
  end
  
  def self.matches(field_name, param)
    # % wild card - doent have tobe exact match as long as the search string as somethin that was found in the field
    where("lower(#{field_name}) like ?", "%#{param}%")
  end
  
end
