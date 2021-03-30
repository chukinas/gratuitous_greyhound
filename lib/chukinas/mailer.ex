# TODO move this to an email dir
defmodule Chukinas.Email do
  import Bamboo.Email

  def feedback_email(feedback)  do
    new_email(
      to: "chukinas@gmail.com",
      from: "jonathan@chukinas.com",
      subject: "Feedback",
      html_body: feedback,
      text_body: feedback
    )
  end

  def test_email do
    new_email(
      to: "chukinas@gmail.com",
      from: "jonathan@chukinas.com",
      subject: "Welcome to the app.",
      html_body: "<strong>This is a test email!</strong>",
      text_body: "This is a test email!"
    )
  end
end

defmodule Chukinas.Mailer do
  use Bamboo.Mailer, otp_app: :chukinas
end
