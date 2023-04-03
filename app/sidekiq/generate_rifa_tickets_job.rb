class GenerateRifaTicketsJob < ApplicationJob
  
  def generate(rifa_id)
    rifa = Rifa.find_by(id: rifa_id)

    return unless rifa

    ActiveRecord::Base.transaction do
      if rifa.rifa_tickets.count >= 12
        logger.info 'Cannot generate tickets for this rifa, tickets already generated!'
        ActiveRecord::Rollback
        return
      end

      case(rifa.loteria)
        when 'Zulia 7A'
          GenerateZulia7ATicketsService.new(rifa).call
          logger.info 'Zulia 7A tickets seeded!'
        when 'Triple Pelotica'
          GenerateTriplePeloticaTicketsService.new(rifa).call
          logger.info 'Triple Pelotica tickets seeded!'
        else
          logger.info "Unsupported loteria: #{rifa.loteria}"
          Rifa.destroy(rifa.id)
          return ActiveRecord::Rollback
        end
    end
  end
end

# +---------------------------------------------------------------------------------------------------------------------------------------------------------------+
# |------------------------------------------------    ▼         WARNINIG!!!        ▼     ------------------------------------------------------------------------|
# |------------------------------------------------    ▼  GENERATOR SERVICES BELOW  ▼     ------------------------------------------------------------------------|
# |------------------------------------------------    ▼         WARNINIG!!!        ▼     ------------------------------------------------------------------------|
# +---------------------------------------------------------------------------------------------------------------------------------------------------------------+

class GenerateZulia7ATicketsService
  def initialize(rifa)
    @rifa = rifa
    @signs = [
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
    ]
  end

  def call
    @rifa.update(serial: SecureRandom.hex(5),
                 expired: @rifa.rifDate + 5.days,
                 tickets_type: 'Signs')
    @signs.each_with_index do |sign, index|
      RifaTicket.create(rifa_id: @rifa.id,
                        serial: SecureRandom.hex(5),
                        sign: sign,
                        ticket_nro: index + 1,
                        number: @rifa.numbers)
    end
  end
end

class GenerateTriplePeloticaTicketsService
  def initialize(rifa)
    @rifa = rifa
    @sports_wildcards = [
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
    ]
  end

  def call
    @rifa.update(serial: SecureRandom.hex(5),
                 expired: @rifa.rifDate + 5.days,
                 tickets_type: 'Wildcards')
    @sports_wildcards.each_with_index do |sport, index|
      RifaTicket.create(rifa_id: @rifa.id,
                        serial: SecureRandom.hex(5),
                        sign: sport,
                        ticket_nro: index + 1,
                        number: @rifa.numbers)
    end
  end
end

# +---------------------------------------------------------------------------------------------------------------------------------------------------------------+
# |------------------------------------------------    ▲         WARNINIG!!!        ▲     ------------------------------------------------------------------------|
# |------------------------------------------------    ▲  GENERATOR SERVICES ABOVE  ▲     ------------------------------------------------------------------------|
# |------------------------------------------------    ▲         WARNINIG!!!        ▲     ------------------------------------------------------------------------|
# +---------------------------------------------------------------------------------------------------------------------------------------------------------------+
