require 'spec_helper'

describe "Viewing the list of users" do

  it "shows the users" do
    user1 = User.create!(user_attributes(username: "larry", name: "Larry", email: "larry@example.com"))
    user2 = User.create!(user_attributes(username: "moe", name: "Moe",   email: "moe@example.com"))
    user3 = User.create!(user_attributes(username: "curly", name: "Curly", email: "curly@example.com"))

    visit users_url

    expect(page).to have_link(user1.name)
    expect(page).to have_link(user2.name)
    expect(page).to have_link(user3.name)
  end

end