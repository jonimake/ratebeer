class CreateStyles < ActiveRecord::Migration
  def change
    create_table :styles do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end

    change_table :beers do |t|
      t.rename :style, :style_old
      t.integer :style_id
    end

    styles = Beer.all.map{|b| b.style_old}.uniq
    styles = styles.map {|s| Style.create name:s, description:""}
    Beer.all.each { |b| b.style_id = styles.select{|s| s.name == b.style_old}.first.id }

    remove_column :beers, :style_old
  end
end
