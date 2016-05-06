feature 'User sign-up' do
  scenario 'user creates an account' do
    expect { sign_up }.to change(User, :count).by(1)
    expect(page).to have_content 'Welcome Michael!'
    expect(User.first.email).to eq 'test@test.co.uk'
  end

  scenario 'user needs to validate his password' do
    expect { sign_up(confirm_password:'110090') }.not_to change(User, :count)
    expect(current_path).to eq '/users/new'
    expect(page).to have_content('Are you trying to cheat me m8?')
  end

  scenario "can't sign up wothout an email address" do
    expect { sign_up(email: nil) }.not_to change(User, :count)
  end

  scenario "can't sign up with an invalid email address" do
    expect { sign_up(email: "invalid@email") }.not_to change(User, :count)
  end

  scenario "can't sign up with an already existing email" do
    sign_up
    expect { sign_up(username: 'daniel')}.not_to change(User, :count)
    expect(page).to have_content('Sorry m8 that email is already taken')
  end

  scenario "can't sign up with an already existing username" do
    sign_up
    expect { sign_up(email: "disney@disney.co.uk") }.not_to change(User, :count)
    expect(page).to have_content('Sorry m8 that username is already taken')
  end
end
