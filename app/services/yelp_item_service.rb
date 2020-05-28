class YelpItemService
  def initialize(attrs = {})
    @activity_array = attrs[:activity_array]
    @activity_items = attrs[:activity_items]
    @starts_at = attrs[:starts_at]
    @ends_at = attrs[:ends_at]
  end

  def call

    result_array = [[], [], []]
    sorted_array = []

    # create result array to funnel items to experiences
    @activity_items.each_value do |value|
      sorted_array = value.sort_by(&:rating).reverse
      item_array = []
      3.times do
        item_array << sorted_array.sample
      end
      item_array.each_with_index do |val, index|
        result_array[index] << val
      end
    end

    # determine whether there is enough time for all activities during the date
    activity_duration_list = @activity_array.pluck(:duration)
    activity_duration = activity_duration_list.sum

    date_duration = ((@ends_at - @starts_at) / 60).to_int
    travel_time = 30
    travel_windows = @activity_array.size - 1

    total_activity_duration = (travel_time * travel_windows) + activity_duration

    # return

    total_activity_duration > date_duration ? result_array[0..(result_array.size - 1)] : result_array
  end
end
