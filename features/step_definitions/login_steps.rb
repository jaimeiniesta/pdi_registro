Dado /^que estoy logado como "(.*)"$/ do |nombre|
    user = Factory.build(:user, :name => nombre)
    user.signup!({:name => user.name, :email => user.email}, false) {}
    user.activate!({:login => user.name, :password => 'secret', :password_confirmation => 'secret'}, false) {}
    visit login_path
    fill_in "Login", :with => user.login
    fill_in "Password", :with => 'secret'
    click_button "Login"
end

Dado /^que estoy logado$/ do
    Dado "que estoy logado como \"cualquier_nombre\""
end


Dado /^que me he registrado con éxito$/ do
  Given "I am an anonymous user"
  When "I go to the registration form"
  And "I fill in \"name\" with \"bob\""
  And "I fill in \"email\" with \"bob@example.com\""
  And "I press \"Register\""
  Then "I should have a successful registration"
end

Dado /^que he recibido el email de activacion$/ do
  Given "\"bob@example.com\" should receive an email"
  When "I open the email"
  Then "I should see \"activate your account\" in the email body"
end

Dado /^que sigo el link "([^\"]*)" en el email$/ do |link|
  visit_in_email(link)
end

Cuando /^relleno el resto de campos del formulario de activacion$/ do
  When "I fill in \"login\" with \"bob\""
  When "I fill in \"set your password\" with \"secret\""
  When "I fill in \"password confirmation\" with \"secret\""
end


Entonces /^vere el formulario de activacion$/ do
  response.should contain('Name') if controller.params[:invitation_token]
  response.should contain('Email') if controller.params[:invitation_token]
  response.should contain('Login')
  response.should contain('Set your password')
  response.should contain('Password confirmation')
  response.should contain('Open ID')
end
