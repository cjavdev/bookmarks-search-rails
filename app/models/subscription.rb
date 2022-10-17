class Subscription < ApplicationRecord
  belongs_to :user

  def active?
    stripe_status == 'active' || stripe_status == 'trialing'
  end
end
