module ArrayExt
  def contains_all?(other)
    return false if length < other.length

    dup_ary = dup
    dup_other = other.dup

    loop do
      # Get next element of the other array
      current_element = dup_other.delete_at(0)
      break if current_element.nil?

      # Check if the current element is in the array
      return false unless dup_ary.include?(current_element)

      # If yes, we remove the current element from
      # the array and continue
      dup_ary.delete_at(dup_ary.index(current_element))

      # If it's empty we can break from the loop
      break if dup_ary.empty?
    end

    dup_other.empty?
  end
end

class Array
  prepend ::ArrayExt
end
