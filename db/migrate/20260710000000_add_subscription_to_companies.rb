# frozen_string_literal: true

class AddSubscriptionToCompanies < ActiveRecord::Migration[8.0]
  def change
    add_column :companies, :plan, :string, default: 'starter', null: false
    add_column :companies, :billing_cycle, :string, default: 'monthly', null: false
    add_column :companies, :subscription_status, :string, default: 'trialing', null: false
    add_column :companies, :trial_ends_at, :datetime
  end
end
