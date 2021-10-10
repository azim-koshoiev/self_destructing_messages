class AddDeletedAtToMessages < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :deleted_at, :datetime, default: nil
  end
end
