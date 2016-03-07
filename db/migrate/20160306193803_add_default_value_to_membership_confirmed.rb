class AddDefaultValueToMembershipConfirmed < ActiveRecord::Migration
  def up
    change_column :memberships, :confirmed, :boolean, :default => false
  end

  def down
    change_column :memberships, :confirmed, :boolean, :default => nil
  end
end
