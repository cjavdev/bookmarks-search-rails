class BillingsController < ApplicationController
  def show
    @portal_session = Stripe::BillingPortal::Session.create(
      customer: current_user.lazy_stripe_customer_id,
    )

    redirect_to @portal_session.url, allow_other_host: true, status: :see_other
  end
end
