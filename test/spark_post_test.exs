defmodule Learnathon.SparkPostTest do
  use Learnathon.DataCase

  test "send a message with sparkpost" do
    SparkPost.send to: "yianna@learnathon.nyc",
    from: "yianna@learnathon.nyc",
    subject: "Sending email from Elixir is awesome!",
    text: "Hi there!",
    html: "<p>Hi there!</p>"
  end

end
