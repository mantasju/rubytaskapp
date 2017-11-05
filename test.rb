require './lib/team'

owner = User.new("krabas", "labas")
team = Team.new(owner, 5)
user = User.new("sgsdg", "gdfbd")
team.add_team_member(user, owner)
team.remove_team_member(user, owner)
puts team.is_player_on_team(user)