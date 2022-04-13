defmodule EnchanterShop do
  @enchanter_name "Edwin"
  def test_data do
    [
      %{title: "Longsword", price: 50, magic: false},
      %{title: "Healing Potion", price: 60, magic: true},
      %{title: "Rope", price: 10, magic: false},
      %{title: "Dragon's Spear", price: 100, magic: true}
    ]
  end

  def enchant_for_sale([]), do: []
  # if this pattern matching match, will exercute the clause
  def enchant_for_sale([item = %{magic: true} | incoming_items]) do
    [item | enchant_for_sale(incoming_items)]
  end

  def enchant_for_sale([item | incomig_items]) do
    new_item = %{
      title: "#{@enchanter_name}'s #{item[:title]}",
      price: item.price * 3,
      magic: true
    }

    [new_item | enchant_for_sale(incomig_items)]
  end
end
