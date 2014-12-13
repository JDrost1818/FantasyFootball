class League < ActiveRecord::Base
	has_many :teams, dependent: :destroy
	accepts_nested_attributes_for :teams, :allow_destroy => true

	validates_length_of :name, :minimum => 5, :maximum => 20, :allow_blank => false

	def close_registration
		puts "\n\n\n\n" + is_open_for_registration.to_s + "\n\n\n\n"
		self.is_open_for_registration = false
		self.save
		puts "\n\n\n\n" + is_open_for_registration.to_s + "\n\n\n\n"
	end

	def get_salary_cap
		(salary_cap / 1000).to_s + "k"
	end
end
