class StripeApiWrapper
  def self.charge(athlete, subscription_plan, stripe_token, stripe_email)
    customer = retrieve_customer(athlete, stripe_token, stripe_email)
    Stripe::Charge.create(
      customer: customer.id,
      amount: (subscription_plan.amount * 100).to_i,
      currency: Settings.app.currency,
      description: subscription_plan.name,
      metadata: {
        'Subscription Plan ID' => subscription_plan.id,
        'Subscription Plan Name' => subscription_plan.name
      }
    )
  end

  private_class_method

  def self.retrieve_customer(athlete, stripe_token, stripe_email) # rubocop:disable MethodLength
    stripe_customer = StripeCustomer.find_by(athlete_id: athlete.id)
    begin
      customer = Stripe::Customer.retrieve(stripe_customer.id) unless stripe_customer.nil? || stripe_customer.id.blank?
    rescue Stripe::StripeError => e
      raise unless e.http_status == 404
      customer = nil
    end

    if customer.blank?
      customer_metadata = {
        'Athelte ID' => athlete.id,
        'Email' => athlete.athlete_info.email,
        'First Name' => athlete.athlete_info.firstname,
        'Last Name' => athlete.athlete_info.lastname,
        'Strava Profile URL' => athlete.profile_url,
        'Strafforts Profile URL' => "#{Settings.app.url}/athletes/#{athlete.id}"
      }
      customer = Stripe::Customer.create(
        source: stripe_token,
        email: stripe_email,
        metadata: customer_metadata
      )

      # Create a new record in stripe_customers table.
      stripe_customer = StripeCustomer.where(id: customer.id).first_or_create
      stripe_customer.email = customer.email
      stripe_customer.athlete_id = athlete.id
      stripe_customer.save
    end

    customer
  end
end
