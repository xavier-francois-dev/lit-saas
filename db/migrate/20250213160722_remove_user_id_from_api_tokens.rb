class RemoveUserIdFromApiTokens < ActiveRecord::Migration[8.0]
  def change
    remove_column :api_tokens, :user_id, :integer
    if index_exists?(:api_tokens, :user_id, name: 'index_api_tokens_on_user_id')
      remove_index :api_tokens, name: 'index_api_tokens_on_user_id'
    end
  end
end
