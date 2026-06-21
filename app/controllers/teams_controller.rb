# frozen_string_literal: true

class TeamsController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = policy_scope(User)
    @invitation_user = User.new
  end
end
