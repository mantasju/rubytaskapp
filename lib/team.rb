require 'user'

class Team

	@@team_players = []

	def initialize(user, team_size)
		@team_owner = user
		@team_size = team_size
	end

	def change_team_owner(user)
		@team_owner = user
	end

	def add_team_member(user_to_add, calling_user) # nezinau, kaip cia igyvendinti viska (reikia prisijungimo ir panasiai), tai dabar palieku sitaip
		raise "You are not the team owner" if @team_owner != calling_user

		raise "User is already on the team" if @@team_players.include? user_to_add

		raise "Team is already full" if @@team_players.length == @team_size

		@@team_players.push(user_to_add)
	end

	def remove_team_member(user_to_remove, calling_user)

	end

	def get_team_member_count()

	end
end