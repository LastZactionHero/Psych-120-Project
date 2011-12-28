class InitTestMeta < ActiveRecord::Migration
  def self.up
    TestMeta.create( { :week => 0 } )
  end

  def self.down
    TestMeta.all.each do |meta|
      meta.delete
    end
  end
end
