module TimeBlock extend ActiveSupport::Concern
  def self.block(start_time, end_time)
    @start_time = start_time
    @end_time = end_time
    @now = Time.now

    @check = @now.between?(@start_time, @end_time)

    if @check
      yield if block_given?
    else
      raise ForbiddenException
    end
  end
end

class ForbiddenException < StandardError
  def initialize(msg = "Can't handle action, system is in hibernation mode")
    super
  end
end