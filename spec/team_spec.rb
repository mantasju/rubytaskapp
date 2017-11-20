# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Team do
  before(:each) do
    @owner_user = User.new('labas', 'krabas', 'a@a.a', 12)
    @user = User.new('baduser', 'badpassword', 'a@a.a', 12)
    @team = Team.new(@owner_user, 5, 'nice_team')
  end

  context 'initialize' do
    it 'should have the assigned team size after creation' do
      expect(@team.team_size).to eq(5)
    end
    it 'should have the correct team owner after creation' do
      expect(@team.team_owner).to eq(@owner_user)
    end
    it 'should have the correct team name after creation' do
      expect(@team.team_name).to eq('nice_team')
    end
  end

  context 'equals' do
    it 'two teams eq if the owner is the same and name is the same' do
      new_team = Team.new(@owner_user, 5, 'nice_team')

      expect(new_team).to eq(@team)
    end

    it 'two teams not eq if the owner is the same but name is not' do
      new_team = Team.new(@owner_user, 5, 'nicee_team')

      expect(new_team).not_to eq @team
    end

    it 'two teams not eq if the owner is not the same but the name is' do
      user = User.new('loluser', 'lolpassword', 'a@a.a', 12)
      new_team = Team.new(user, 5, 'nice_team')

      expect(new_team).not_to eq @team
    end
  end

  context 'team owner' do
    it 'should only allow team owner to change team owner' do
      expect { @team.change_team_owner(@user, @user) }
        .to raise_error('Only team owner can change the team owner')
    end
    it 'should change team owner' do
      @team.change_team_owner(@user, @owner_user)
      expect(@team.team_owner).to eq(@user)
    end

    it 'should not allow to change team owner to nil' do
      expect { @team.change_team_owner(nil, @owner_user) }
        .to raise_error('New team owner can\'t be nil')
    end
  end

  context 'add members' do
    it 'should not allow action if you are not team owner' do
      expect { @team.add_team_member(@user, @user) }
        .to raise_error('You are not the team owner')
    end

    it 'should not allow to add the same user twice' do
      @team.add_team_member(@user, @owner_user)
      expect { @team.add_team_member(@user, @owner_user) }
        .to raise_error('User is already on the team')
    end

    it 'should not allow to add new members after reached limit' do
      expect do
        (1..10).to_a.each do |i|
          user = User.new("#{i}a.join}", 'asd', 'a@a.a', 15)
          @team.add_team_member(user, @owner_user)
        end
      end.to raise_error('Team is already full')
    end

    it 'should not allow to add a nil member' do
      expect { @team.add_team_member(nil, @owner_user) }
        .to raise_error('User to add cannot be nil')
    end

    it 'should succesfully add a member' do
      @team.add_team_member(@user, @owner_user)
      expect(@team.player_on_team?(@user)).to be true
    end
  end

  context 'remove members' do
    it 'should not allow allow action if you are not team owner' do
      expect { @team.remove_team_member(@user, @user) }
        .to raise_error('You are not the team owner')
    end

    it 'should succesfully remove a member' do
      @team.add_team_member(@user, @owner_user)
      @team.remove_team_member(@user, @owner_user)
      expect(@team.player_on_team?(@user)).to be false
    end
  end
end
