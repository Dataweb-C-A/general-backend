class GenerateRifaTicketsJob
  include Sidekiq::Job

  ZODIAC_SIGNS = [
    'Aries',
    'Tauro',
    'Geminis',
    'Cancer',
    'Leo',
    'Virgo',
    'Libra',
    'Escorpio',
    'Sagitario',
    'Capricornio',
    'Acuario',
    'Piscis'
  ].freeze

  SPORTS_WILDCARDS = [
    'Baloncesto',
    'Beisbol',
    'Futbol',
    'Voleibol',
    'Playa',
    'Golf',
    'Futbol Americano',
    'Tenis',
    'Billar',
    'Bowling',
    'Ping Pong',
    'Hockey',
  ].freeze

  def generate(rifa_id)
    rifa = Rifa.find_by(id: rifa_id)

    return unless rifa

    ActiveRecord::Base.transaction do
      rifa.update(serial: SecureRandom.hex(5),
                  expired: rifa.rifDate + 5.days,
                  tickets_type: rifa.loteria === 'Zulia 7A' ? 'Signs' : 'Wildcards')

      if (rifa.loteria === 'Zulia 7A')
        ZODIAC_SIGNS.each_with_index do |sign, index|
          RifaTicket.create(rifa_id: rifa_id,
                            serial: SecureRandom.hex(5),
                            sign: sign,
                            ticket_nro: index + 1,
                            number: rifa.numbers,
                            is_sold: false)
        end
        Rails.logger.info 'Zulia 7A tickets seeded!'
      elsif (rifa.loteria === 'Triple Pelotica')
        SPORTS_WILDCARDS.each_with_index do |sport, index|
          RifaTicket.create(rifa_id: rifa_id,
                            sign: sport,
                            serial: SecureRandom.hex(5),
                            ticket_nro: index + 1,
                            number: rifa.numbers,
                            is_sold: false)
        end
        Rails.logger.info 'Triple Pelotica tickets seeded!'
      else
        Rails.logger.info "Unsupported loteria: #{rifa.loteria}"
      end
    end
  end
end
