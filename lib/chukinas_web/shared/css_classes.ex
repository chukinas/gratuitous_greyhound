defmodule ChukinasWeb.CssClasses do

  def join(a, b), do: Enum.join([a, b], " ")

  def text_input(:valid), do: join text_input(:both), "appearance-none px-3 py-2 border border-gray-300 shadow-sm placeholder-gray-400 focus:outline-none focus:ring-yellow-700 focus:border-yellow-700 disabled:text-gray-500"
  def text_input(:invalid), do: join text_input(:both), "pr-10 border-red-300 text-red-900 placeholder-red-300 focus:outline-none focus:ring-red-500 focus:border-red-500"
  def text_input(:both), do: "block w-full focus:outline-none sm:text-sm rounded-md disabled:#{bg :light} disabled:shadow-none"

  def label, do: "block text-sm font-medium #{text :dark}"

  def error_paragraph, do: "mt-2 text-sm text-red-600"

  def submit, do: "w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white disabled:text-gray-400 bg-yellow-700 disabled:bg-gray-200 disabled:cursor-not-allowed hover:bg-yellow-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-yellow-500"

  def menu_tab(true = _active?), do: join(menu_tab(:both), "border-yellow-700 text-yellow-900 font-bold")
  def menu_tab(false = _active?), do: join(menu_tab(:both), "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300")
  def menu_tab(:both), do: "inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium"

  def menu_profile_mobile(true = _active?), do: join(menu_profile_mobile(:both), "bg-yellow-200 border-yellow-500 #{text :dark} font-bold")
  def menu_profile_mobile(false = _active?), do: join(menu_profile_mobile(:both), "border-transparent text-gray-600 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-800")
  def menu_profile_mobile(:both), do: "block pl-3 pr-4 py-2 border-l-4 text-base font-medium"

  def menu_nav, do: "#{bg(:light)} shadow-sm"

  def bg(:light), do: "bg-yellow-50"

  def text(:dark), do: "text-yellow-900"

end
