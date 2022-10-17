class User < ApplicationRecord
  has_many :subscriptions

  def subscribed?
    subscriptions.any?(&:active?)
  end

  def lazy_stripe_customer_id
    return stripe_customer_id if stripe_customer_id
    customer = Stripe::Customer.create(metadata: {
      user_id: id,
    })

    update(stripe_customer_id: customer.id)
    customer.id
  end
end
