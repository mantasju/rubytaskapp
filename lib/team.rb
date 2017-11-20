# frozen_string_literal: true

require_relative 'user'

# The Team class is responsible for defining a team in the app
class Team
  attr_reader :team_size, :team_owner, :team_name

  def initialize(user, team_size, team_name)
    @team_owner = user
    @team_size = team_size
    @team_players = []
    @team_name = team_name
  end

  def change_team_owner(user_to_change_to, calling_user)
    unless calling_user.equal?(team_owner)
      raise 'Only team owner can change the team owner'
    end
    raise 'New team owner can\'t be nil' if user_to_change_to.equal?(nil)
    @team_owner = user_to_change_to
  end

  def add_team_member(user_to_add, calling_user)
    raise 'User to add cannot be nil' if user_to_add.equal?(nil)
    raise 'You are not the team owner' unless team_owner.equal?(calling_user)
    raise 'Team is already full' if @team_players.length.equal?(team_size)
    raise 'User is already on the team' if @team_players.include? user_to_add
    @team_players.push(user_to_add)
  end

  def remove_team_member(user_to_remove, calling_user)
    raise 'You are not the team owner' unless team_owner.equal?(calling_user)
    @team_players.delete(user_to_remove)
  end

  def player_on_team?(user_to_check)
    @team_players.include? user_to_check
  end

  def ==(other)
    other.team_owner.equal?(team_owner) && other.team_name.equal?(team_name)
  end
end
