defmodule ChukinasWeb.CssClasses do

  def text_input(:valid), do: "appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-yellow-700 focus:border-yellow-700 sm:text-sm"

  def text_input(:invalid), do: "block w-full pr-10 border-red-300 text-red-900 placeholder-red-300 focus:outline-none focus:ring-red-500 focus:border-red-500 sm:text-sm rounded-md"

  def label, do: "block text-sm font-medium text-gray-700"

  def error_paragraph, do: "mt-2 text-sm text-red-600"

  def submit, do: "w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white disabled:text-gray-400 bg-yellow-700 disabled:bg-gray-200 disabled:cursor-not-allowed hover:bg-yellow-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-yellow-500"

end
