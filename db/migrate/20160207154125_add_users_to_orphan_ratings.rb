class AddUsersToOrphanRatings < ActiveRecord::Migration
  def change
    u = User.first
    if not u.nil?
      Rating.all.each{ |r| u.ratings << r }
    else
      Rating.all.each{ |r| r.destroy}
    end
  end
end
