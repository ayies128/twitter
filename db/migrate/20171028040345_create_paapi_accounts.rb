class CreatePaapiAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :paapi_accounts do |t|
      t.string :associate_tag
      t.string :access_key_id
      t.string :secret_key
      t.timestamps
    end
  end
end
