class CheckoutsController < ApplicationController
  before_action :require_user!

  def show
  end

  def create
    @checkout_session = Stripe::Checkout::Session.create(
      customer: current_user.lazy_stripe_customer_id,
      success_url: bookmarks_url,
      cancel_url: checkout_url,
      mode: "subscription",
      line_items: [{
        price: "price_1LGrRJCZ6qsJgndJhz35LZzj",
        quantity: 1,
      }],
      subscription_data: {
        metadata: {
          user_id: current_user.id,
        },
      },
    )

    redirect_to @checkout_session.url, allow_other_host: true, status: :see_other
  end
end
