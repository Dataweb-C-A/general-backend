class ToolsRedis 
  def self.redis_update_places(draw_id, place_number)
    redis = Redis.new
    data = JSON.parse(redis.get("places:#{draw_id}"))

    draw_index = data.find_index{|a| a["place_number"] == place_number}
    data[draw_index]["is_sold"] = true

    redis.set("places:#{draw_id}", data.to_json)
  end

  def self.redis_update_winner(draw_id)
    redis = Redis.new
    data = JSON.parse(redis.get("places:#{draw_id}"))

    draw_index = data.find_index{|a| a["place_number"] == data.sample["place_number"]}
    data[draw_index]["is_winner"] = true

    redis.set("places:#{draw_id}", data.to_json)
  end
end
