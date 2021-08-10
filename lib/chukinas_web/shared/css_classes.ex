defmodule ChukinasWeb.CssClasses do

  def join(a, b), do: Enum.join([a, b], " ")

  def text_input(:valid), do: join text_input(:both), "appearance-none px-3 py-2 border border-gray-300 shadow-sm placeholder-gray-400 focus:outline-none focus:ring-yellow-700 focus:border-yellow-700 disabled:text-gray-500"
  def text_input(:invalid), do: join text_input(:both), "pr-10 border-red-300 text-red-900 placeholder-red-300 focus:outline-none focus:ring-red-500 focus:border-red-500"
  def text_input(:both), do: "block w-full focus:outline-none sm:text-sm rounded-md disabled:#{bg :light} disabled:shadow-none"

  def label, do: "block text-sm font-medium #{text :dark}"

  def error_paragraph, do: "mt-2 text-sm text-red-600"

  def submit, do: join btn_common(), "w-full flex justify-center border-transparent shadow-sm focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-yellow-500"
  def join_btn, do: join btn_common(), "-ml-px inline-flex items-center space-x-2 border-gray-300 rounded-l-none focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500"
  def btn_common, do: "py-2 px-4 border rounded-md text-sm text-white disabled:text-gray-400 font-medium bg-yellow-700 hover:bg-yellow-800 disabled:bg-gray-200 disabled:cursor-not-allowed "

  def bg(:light), do: "bg-yellow-50"

  def text(:dark), do: "text-yellow-900"

end
