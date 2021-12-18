class Array
  def float_sum
    inject(0.0) { |result, el| result + el }
  end

  def average
    (float_sum / size).round(2)
  end
end
