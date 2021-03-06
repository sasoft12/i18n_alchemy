require "test_helper"
require "action_pack"

class ActionViewTest < I18n::Alchemy::TestCase
  def setup
    @template  = ActionView::Base.respond_to?(:empty) ? ActionView::Base.empty : ActionView::Base.new
    @product   = Product.new(
      name: "Potato",
      quantity: 10,
      price: 1.99,
      released_at: Date.new(2011, 2, 28),
      last_sale_at: Time.mktime(2011, 2, 28, 13, 25, 30)
    )
    @localized = @product.localized

    I18n.locale = :pt
  end

  def teardown
    I18n.locale = :en
  end

  def test_text_field_with_string_attribute
    assert_same_text_input :name, 'Potato'
  end

  def test_text_field_with_integer_attribute
    assert_same_text_input :quantity, '10'
  end

  def test_text_field_with_decimal_attribute
    assert_same_text_input :price, '1,99'
  end

  def test_text_field_with_date_attribute
    assert_same_text_input :released_at, '28/02/2011'
  end

  def test_text_field_with_time_attribute
    assert_same_text_input :last_sale_at, '28/02/2011 13:25:30'
  end

  private

  # Since we do not want to rely on Rails dom-assertions (neither from the
  # framework nor from the extracted gem), we build our own :).
  def assert_same_text_input(attribute, value)
    assert_equal(
      %Q[<input type="text" value="#{value}" name="product[#{attribute}]" id="product_#{attribute}" />],
      @template.text_field(:product, attribute, object: @localized)
    )
  end
end
