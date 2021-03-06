module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      root_path
    when /the login page/
      login_path
    when /the logout page/
      logout_path
    when /the account page/
      account_path
    when /the account editing page/
      edit_account_path
    when /my dashboard page/
      dashboard_path

    when /the signup page/
      signup_path
    when /the registration form/
      signup_path
    when /the activation form/
      register_path
    when /the confirm page with bad token/
      register_path

    when /the reset password page/
      new_password_reset_path
    when /the change password form with bad token/
      edit_password_reset_path('bad')

    when /the invitation request form/
      apply_invitations_path
    when /the invitation accept form with bad token/
      accept_path('bad')

    when /the admin root page/
      admin_root_path
    when /the invitations list page/
      admin_invitations_path
    
    when /the activation page with activation code (.*)/
      activate_path(:id => $1)

    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
