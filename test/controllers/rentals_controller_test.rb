require 'test_helper'

class RentalsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @rental = rentals(:one)
    @user = users(:michael)
    @item = items(:one)
  end

  test "rented item availability should be false" do
    log_in_as(@user)
    assert(@item.available)
    post rent_path(item_id: @item.id)
    assert_not(@item.reload.available)
  end

  test "checked in item availablility should be true" do
    log_in_as(@user)
    post rent_path(item_id: @item.id)
    assert_not(@item.reload.available)
    post checkin_path(item_id: @item.id)
    assert(@item.reload.available)
  end

  test "should rent item then check item back in" do
    log_in_as(@user)
    assert_difference('Rental.count') do
      post rent_path(item_id: @item.id)
    end

    assert_redirected_to @item
    assert_equal Rental.last.item_id, @item.id

    post checkin_path(item_id: @item.id)
    assert Rental.last.history = true
  end

end
