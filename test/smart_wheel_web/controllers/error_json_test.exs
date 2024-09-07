defmodule SmartWheelWeb.ErrorJSONTest do
  use SmartWheelWeb.ConnCase, async: true

  test "renders 404" do
    assert SmartWheelWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert SmartWheelWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
