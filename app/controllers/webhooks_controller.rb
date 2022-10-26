class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    event = nil
    signature = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secrets = Rails.application.credentials.dig(:stripe, :webhook_secrets)

    # Retrieve the event by verifying the signature using the raw body and secret.
    begin
      event = Stripe::Webhook.construct_event(
        payload, signature, endpoint_secrets.first
      )
    rescue Stripe::SignatureVerificationError
      begin
        event = Stripe::Webhook.construct_event(
          payload, signature, endpoint_secrets.last
        )
      rescue Stripe::SignatureVerificationError => err
        puts "⚠️  Webhook signature verification failed. #{err.message})"
        status 400
      end
    end

    case event.type
    when 'customer.subscription.created'
      subscription = event.data.object
      user = User.find_by(id: subscription.metadata.user_id)
      sub = user.subscriptions.create(
        stripe_id: subscription.id,
        stripe_status: subscription.status,
      )
    when 'customer.subscription.updated', 'customer.subscription.deleted'
      subscription = event.data.object # contains a Stripe::Subscription object
      sub = Subscription.find_by(stripe_id: subscription.id)
      sub.update(stripe_status: subscription.status)
    end
  end
end
