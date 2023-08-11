# == Schema Information
#
# Table name: quadres
#
#  id         :bigint           not null, primary key
#  day        :date
#  gastos     :float
#  total      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  agency_id  :integer
#
class Quadre < ApplicationRecord
  has_many :denomination

  after_commit :create_denominations
  
  def create_denominations
    begin
      puts "Creating denominations for Quadre #{self.id}"
      @USD = [
        { power: 100, quantity: 0, money: '$', category: 'CASH', label: '100$', ammount: nil }, 
        { power: 50, quantity: 0, money: '$', category: 'CASH', label: '50$', ammount: nil }, 
        { power: 20, quantity: 0, money: '$', category: 'CASH', label: '20$', ammount: nil }, 
        { power: 10, quantity: 0, money: '$', category: 'CASH', label: '10$', ammount: nil }, 
        { power: 5, quantity: 0, money: '$', category: 'CASH', label: '5$', ammount: nil }, 
        { power: 2, quantity: 0, money: '$', category: 'CASH', label: '2$', ammount: nil }, 
        { power: 1, quantity: 0, money: '$', category: 'CASH', label: '1$', ammount: nil }, 
        { power: nil, quantity: nil, money: '$', category: 'TRANSFER', label: 'Zelle', ammount: nil }, 
        { power: nil, quantity: 0, money: '$', category: 'TRANSFER', label: 'Sencillo', ammount: nil }, 
        { power: nil, quantity: 0, money: '$', category: 'DEBT', label: 'Gastos', ammount: nil }, 
      ]
    
      @BSD = [
        { power: 100, quantity: 0, money: 'Bs.D', category: 'CASH', label: '100 Bs.D', ammount: nil }, 
        { power: 50, quantity: 0, money: 'Bs.D', category: 'CASH', label: '50 Bs.D', ammount: nil }, 
        { power: 20, quantity: 0, money: 'Bs.D', category: 'CASH', label: '20 Bs.D', ammount: nil }, 
        { power: 10, quantity: 0, money: 'Bs.D', category: 'CASH', label: '10 Bs.D', ammount: nil }, 
        { power: 5, quantity: 0, money: 'Bs.D', category: 'CASH', label: '5 Bs.D', ammount: nil }, 
        { power: 1, quantity: 0, money: 'Bs.D', category: 'CASH', label: '1 Bs.D', ammount: nil }, 
        { power: 0.5, quantity: 0, money: 'Bs.D', category: 'CASH', label: '0.5 Bs.D', ammount: nil }, 
        { power: nil, quantity: nil, money: 'Bs.D', category: 'TRANSFER', label: 'Pago Movil', ammount: nil }, 
        { power: nil, quantity: 0, money: 'Bs.D', category: 'TRANSFER', label: 'Sencillo', ammount: nil }, 
        { power: nil, quantity: 0, money: 'Bs.D', category: 'DEBT', label: 'Gastos', ammount: nil }, 
      ]
    
      @COP = [
        { power: 100000, quantity: 0, money: 'COP', category: 'CASH', label: '100.000 COP', ammount: nil }, 
        { power: 50000, quantity: 0, money: 'COP', category: 'CASH', label: '50.000 COP', ammount: nil }, 
        { power: 20000, quantity: 0, money: 'COP', category: 'CASH', label: '20.000 COP', ammount: nil }, 
        { power: 10000, quantity: 0, money: 'COP', category: 'CASH', label: '10.000 COP', ammount: nil }, 
        { power: 5000, quantity: 0, money: 'COP', category: 'CASH', label: '5.000 COP', ammount: nil }, 
        { power: 2000, quantity: 0, money: 'COP', category: 'CASH', label: '2.000 COP', ammount: nil }, 
        { power: 1000, quantity: 0, money: 'COP', category: 'CASH', label: '1.000 COP', ammount: nil }, 
        { power: nil, quantity: nil, money: 'COP', category: 'TRANSFER', label: 'Transferencia', ammount: nil }, 
        { power: nil, quantity: 0, money: 'COP', category: 'TRANSFER', label: 'Sencillo', ammount: nil }, 
        { power: nil, quantity: 0, money: 'COP', category: 'DEBT', label: 'Gastos', ammount: nil }, 
      ]

      @USD.each do |denomination|
        @denomination = Denomination.create!(
          money: denomination[:money],
          power: denomination[:power],
          quantity: denomination[:quantity],
          category: denomination[:category],
          label: denomination[:label],
          ammount: denomination[:ammount],
          quadre_id: self.id
        )
      end

      @BSD.each do |denomination|
        @denomination = Denomination.create!(
          money: denomination[:money],
          power: denomination[:power],
          quantity: denomination[:quantity],
          category: denomination[:category],
          label: denomination[:label],
          ammount: denomination[:ammount],
          quadre_id: self.id
        )
      end

      @COP.each do |denomination|
        @denomination = Denomination.create!(
          money: denomination[:money],
          power: denomination[:power],
          quantity: denomination[:quantity],
          category: denomination[:category],
          label: denomination[:label],
          ammount: denomination[:ammount],
          quadre_id: self.id
        )
      end
    rescue => e
      puts "Error creating denominations: #{e.message}"
      raise e  # Re-raise the exception to trigger a rollback
    end
  end

  def self.create_quadres 
    @agencies = Whitelist.all
    @day_quadre = Quadre.where(day: Date.today)
    if (@day_quadre.length == 0)
      @agencies.each do |agency|
        @quadre = Quadre.new
        @quadre.agency_id = agency.user_id
        @quadre.day = Date.today
        @quadre.total = 0
        @quadre.gastos = 0
        @quadre.save
      end
    end
  end
end
