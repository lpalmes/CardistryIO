require "rails_helper"

feature "appearances" do
  let(:user) { create :user }

  scenario "making a video contain move appearances" do
    move = create :move, user: user
    video = create :video, user: user

    visit root_path(as: user)
    click_link "My videos"
    click_link video.name
    click_link "Edit move appearances"
    select move.name, from: "Move name"
    fill_in "Minutes", with: "1"
    fill_in "Seconds", with: "23"
    click_button "Submit"

    expect(page).to have_content "Moves in this video"
    expect(page).to have_content move.name
    expect(page).to have_content "01:23"
  end

  scenario "remove all video appearances" do
    move = create :move, user: user
    video = create :video, user: user
    create :appearance, video: video, move: move, minutes: 1, seconds: 1

    visit root_path(as: user)
    click_link "My videos"
    click_link video.name
    click_link "Edit move appearances"
    click_button "Delete all appearances"

    expect(page).to have_content "No move appearances added"
  end

  scenario "show video on edit page, as reference" do
    move = create :move, user: user
    video = create :video, user: user
    create :appearance, video: video, move: move, minutes: 1, seconds: 1

    visit root_path(as: user)
    click_link "My videos"
    click_link video.name
    click_link "Edit move appearances"

    expect(page).to have_css "iframe"
  end

  scenario "can only edit move appearances if owns the video" do
    move = create :move, user: user
    video = create :video, user: user

    visit video_path(video)

    expect(page).not_to have_content "Edit move appearances"
  end
end