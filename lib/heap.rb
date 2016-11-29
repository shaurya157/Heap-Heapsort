class BinaryMinHeap
  def initialize(&prc)
    @prc = prc || Proc.new { |el1, el2| el1 <=> el2 }
    @store = []
  end

  def count
    @store.length
  end

  def extract
    raise 'no element to extract' if count == 0
    
    if store.length == 1
      return @store.pop
    else
      @store[0], @store[count - 1] = @store[count - 1], @store[0]
      val = @store.pop
      BinaryMinHeap.heapify_down(@store, 0, @prc)
      return @store.pop
    end
  end

  def peek
  end

  def push(val)
    @store << val
    BinaryMinHeap.heapify_up(@store, count - 1, @prc)
  end

  protected
  attr_accessor :prc, :store

  public
  def self.child_indices(len, parent_index)
    index1 = (parent_index * 2) + 1
    index2 = (parent_index * 2) + 2
    [index1, index2].select { |idx| idx < len }
  end

  def self.parent_index(child_index)
    raise 'root has no parent' if child_index.zero?
    (child_index - 1) / 2
  end

  def self.heapify_down(array, parent_idx, len = array.length, &prc)
    prc ||= Proc.new { |el1, el2| el1 <=> el2 }

    child_indices = self.child_indices(len, parent_idx)
    children = child_indices.map {|num| array[num]}
    parent_value = array[parent_idx]

    return array if children.all? { |child_value| prc.call(parent_value, child_value) <= 0 }

    swap_idx = nil
    if children.length == 1
      swap_idx = children[0]
    else
      swap_idx = prc.call(children[0], children[1]) == -1 ? child_indices[0] : child_indices[1]
    end

    array[parent_idx], array[swap_idx] = array[swap_idx], parent_value
    heapify_down(array, swap_idx, len, &prc)
  end

  def self.heapify_up(array, child_idx, len = array.length, &prc)
    prc ||= Proc.new { |el1, el2| el1 <=> el2 }

    return array if child_idx == 0
    parent_idx = self.parent_index(child_idx)

    if prc.call(array[child_idx], array[parent_idx]) <= 0
      array[child_idx], array[parent_idx] = array[parent_idx], array[child_idx]
      heapify_up(array, parent_idx, len, &prc)
    else
      return array
    end
  end
end
