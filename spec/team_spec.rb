require 'spec_helper'

RSpec.describe Team do

	context "add members" do
		it "should not allow add members if you are not team owner" do
		owner_user = User.new("labas", "krabas")
		team = Team.new(owner_user, 5)
		user = User.new("baduser", "1")
		expect{team.add_team_member(user, user)}.to raise_error("You are not the team owner")		
		end
	end

end