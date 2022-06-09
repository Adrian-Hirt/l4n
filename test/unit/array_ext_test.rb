require 'test_helper'

module Unit
  class ArrayExtTest < ApplicationTest
    def test_both_empty
      assert [].contains_all? []
    end

    def test_self_empty
      assert_not [].contains_all? [1]
      assert_not [].contains_all? [1, 2, 3, 4, 5]
      assert_not [].contains_all? [true]
      assert_not [].contains_all? [false]
      assert_not [].contains_all? [:foo]
      assert_not [].contains_all? ['bar']
      assert_not [].contains_all? [[]]
      assert_not [].contains_all? [1, true, :bar]
    end

    def test_other_empty
      assert [1].contains_all? []
      assert [1, 2, 3, 4, 5].contains_all? []
      assert [true].contains_all? []
      assert [false].contains_all? []
      assert [:foo].contains_all? []
      assert ['bar'].contains_all? []
      assert [[]].contains_all? []
      assert [1, true, :bar].contains_all? []
    end

    def test_contains
      assert [1].contains_all? [1]
      assert [1, 1, 1].contains_all? [1]
      assert [true, :bar, 1, 'foo'].contains_all? [1]
      assert [true, :bar, 1, 'foo'].contains_all? [1, 'foo', true, :bar]
      assert [1, 2, 3, 4, 5, 4, 4, 3, 2, 1].contains_all? [1, 1, 2, 2]
      assert [1, 2, 3, 4, 5, 4, 4, 3, 2, 1].contains_all? [1, 1, 2, 2, 3, 3, 4, 4, 4, 5]
    end

    def test_contains_not
      assert_not [2].contains_all? [1]
      assert_not [2, 2, 2].contains_all? [1]
      assert_not [true, :bar, 2, 'foo'].contains_all? [1]
      assert_not [true, :bar, 2, 'foo'].contains_all? [1, 'foo', true, :bar]
      assert_not [9, 2, 3, 4, 5, 4, 4, 3, 2, 1].contains_all? [1, 1, 2, 2]
      assert_not [9, 2, 3, 4, 5, 4, 4, 3, 2, 1].contains_all? [1, 1, 2, 2, 3, 3, 4, 4, 4, 5]
    end
  end
end
