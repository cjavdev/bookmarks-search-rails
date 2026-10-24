# Brings the pay tables created by pay 4 up to what pay 12 expects: the
# columns pay 5–7 added to its install migration, the STI type columns
# (pay's 2_add_pay_sti_columns) and the object columns (pay 11).
class UpgradePayTablesToV12 < ActiveRecord::Migration[8.1]
  def up
    add_column :pay_customers, :stripe_account, :string
    add_column :pay_payment_methods, :stripe_account, :string
    add_column :pay_charges, :stripe_account, :string

    change_table :pay_subscriptions do |t|
      t.datetime :current_period_start
      t.datetime :current_period_end
      t.boolean :metered
      t.string :pause_behavior
      t.datetime :pause_starts_at
      t.datetime :pause_resumes_at
      t.string :stripe_account
      t.string :payment_method_id
    end
    add_index :pay_subscriptions, :metered
    add_index :pay_subscriptions, :pause_starts_at

    add_column :pay_customers, :type, :string
    add_column :pay_charges, :type, :string
    add_column :pay_subscriptions, :type, :string
    rename_column :pay_payment_methods, :type, :payment_method_type
    add_column :pay_payment_methods, :type, :string
    add_column :pay_merchants, :type, :string

    execute <<~SQL
      UPDATE pay_customers SET type = 'Pay::' || replace(initcap(replace(processor, '_', ' ')), ' ', '') || '::Customer';
      UPDATE pay_merchants SET type = 'Pay::' || replace(initcap(replace(processor, '_', ' ')), ' ', '') || '::Merchant';
      UPDATE pay_charges SET type = 'Pay::' || replace(initcap(replace(c.processor, '_', ' ')), ' ', '') || '::Charge'
        FROM pay_customers c WHERE c.id = pay_charges.customer_id;
      UPDATE pay_subscriptions SET type = 'Pay::' || replace(initcap(replace(c.processor, '_', ' ')), ' ', '') || '::Subscription'
        FROM pay_customers c WHERE c.id = pay_subscriptions.customer_id;
      UPDATE pay_payment_methods SET type = 'Pay::' || replace(initcap(replace(c.processor, '_', ' ')), ' ', '') || '::PaymentMethod'
        FROM pay_customers c WHERE c.id = pay_payment_methods.customer_id;
    SQL

    add_column :pay_charges, :object, :jsonb
    add_column :pay_customers, :object, :jsonb
    add_column :pay_subscriptions, :object, :jsonb
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
