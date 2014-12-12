class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :teams
  has_many :leagues, :through => :teams

  def add_team(team)
  	teams << team
  	save
  end

  def full_name
   	return first_name + " " + last_name
  end
end
