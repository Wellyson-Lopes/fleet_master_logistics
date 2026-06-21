# frozen_string_literal: true

class TeamsController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = UserPolicy::Scope.new(current_user, User).resolve
    @invitation_user = User.new
  end
end
