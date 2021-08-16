# TODO move this to an email dir
defmodule Dreadnought.Email do
  import Bamboo.Email

  def feedback_email(feedback)  do
    new_email(
      to: "dreadnought@gmail.com",
      from: "jonathan@dreadnought.com",
      subject: "Feedback",
      html_body: feedback,
      text_body: feedback
    )
  end

  def test_email do
    new_email(
      to: "dreadnought@gmail.com",
      from: "jonathan@dreadnought.com",
      subject: "Welcome to the app.",
      html_body: "<strong>This is a test email!</strong>",
      text_body: "This is a test email!"
    )
  end
end

defmodule Dreadnought.Mailer do
  use Bamboo.Mailer, otp_app: :dreadnought
end
