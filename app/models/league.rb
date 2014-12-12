class League < ActiveRecord::Base
	has_many :teams, dependent: :destroy
	accepts_nested_attributes_for :teams, :allow_destroy => true

	validates_length_of :name, :minimum => 5, :maximum => 20, :allow_blank => false

	def close_registration
		is_open_for_registration = false
	end

	def get_salary_cap
		(salary_cap / 1000).to_s + "k"
	end
end
