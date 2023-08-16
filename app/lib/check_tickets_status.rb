def check_tickets_status(draw_id, place_positions)
  @draw = Draw.find(draw_id)

  return unless @draw

  @places_sold = Draw.where(draw_id: draw_id, place_numbers: place_positions)

  if @places_sold.length == 0
    return false
  else
    return true
  end
end