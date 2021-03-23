# TODO move this to an email dir
defmodule Chukinas.Email do
  import Bamboo.Email

  def test_email do
    new_email(
      to: "chukinas@gmail.com",
      from: "jonathan@chukinas.com",
      subject: "Welcome to the app.",
      html_body: "<strong>Thanks for joining!</strong>",
      text_body: "Thanks for joining!"
    )
  end
end

defmodule Chukinas.Mailer do
  use Bamboo.Mailer, otp_app: :chukinas
end
