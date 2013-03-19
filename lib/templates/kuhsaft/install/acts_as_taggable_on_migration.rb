class ActsAsTaggableOnMigration < ActiveRecord::Migration
  def self.up
    
    rename_column :contents, :tags, :old_tags
    
    create_table :tags do |t|
      t.string :name
    end

    create_table :taggings do |t|
      t.references :tag

      # You should make sure that the column created is
      # long enough to store the required class names.
      t.references :taggable, :polymorphic => true
      t.references :tagger, :polymorphic => true

      t.string :context

      t.datetime :created_at
    end

    add_index :taggings, :tag_id
    add_index :taggings, [:taggable_id, :taggable_type, :context]
    
    Kuhsaft::PagePart::Content.all.each do |c|
      c.tag_list = c.old_tags.gsub(' ', ', ') unless c.old_tags.blank?
    end
    
    remove_column(:contents, :old_tags)
  end

  def self.down
    drop_table :taggings
    drop_table :tags
  end
end