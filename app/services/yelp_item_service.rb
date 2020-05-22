class YelpItemService
  def initialize(attrs = {})
    @activity_array = attrs[:activity_array]
    @activity_items = attrs[:activity_items]
    @starts_at = attrs[:starts_at]
    @ends_at = attrs[:ends_at]
  end

  def call
    first = nil
    second = nil
    third = nil
    result_array = [[], [], []]
    @activity_items.each_value do |value|
      sorted_array = value.sort_by(&:rating).reverse
      item_list = sorted_array[0..(sorted_array.size / 2)]

      item_array = assign_item_objects(first, second, third, item_list)
      item_array.each_with_index do |val, index|
        result_array[index] << val
      end
    end

    activity_duration_list = @activity_array.pluck(:duration)
    activity_duration = activity_duration_list.sum

    date_duration = ((@ends_at - @starts_at) / 60).to_int
    travel_time = 30
    travel_windows = @activity_array.size - 1

    total_activity_duration = (travel_time * travel_windows) + activity_duration

    # return

    total_activity_duration > date_duration ? result_array[0..(result_array.size - 1)] : result_array
  end

  private

  def assign_item_objects(first, second, third, item_list)
    if first.nil?
      first = item_list.sample
      second = item_list.sample
      third = item_list.sample
    end
    if first == second
      second = item_list.sample
      assign_item_objects(first, second, third, item_list)
    elsif first == third || second == third
      third = item_list.sample
      assign_item_objects(first, second, third, item_list)
    else
      return [first, second, third]
    end
  end
end
