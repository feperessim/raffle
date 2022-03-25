class CreateLotteries < ActiveRecord::Migration[7.0]
  def change
    create_table :lotteries do |t|
      t.date :raffle_date
      t.references :person, null: false, foreign_key: true

      t.timestamps
    end
  end
end
