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

	def get_fa_by_pos pos 
		player_list = []
		Player.all.each do |p|
	      if (teams.to_a & p.teams).empty? and p.position == pos then
	        player_list.push(p)
	      end
	    end
	    return player_list
	end

	def get_all_fa 
		qb = []; rb = []; wr = []; te = []; k = [];
		Player.all.each do |p|
	      if (teams.to_a & p.teams).empty? then
	      	if 	  p.position == "QB" then qb.push p
	        elsif p.position == "RB" then rb.push p
	        elsif p.position == "WR" then wr.push p
	        elsif p.position == "TE" then te.push p
	        elsif p.position == "K"  then k.push p  end	
	      end
	    end
	    return qb, rb, wr, te, k
	end
end
