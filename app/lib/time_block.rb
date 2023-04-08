class TimeBlock 
  def initialize(start_time, end_time)
    @start_time = start_time
    @end_time = end_time
    @now = Time.now
  end

  def block_time
    @now.between?(@start_time, @end_time)
  end
end