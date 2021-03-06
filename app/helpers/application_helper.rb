# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def secure_mail_to(email, name = nil)
    return name if email.blank?
    mail_to email, name, :encode => 'javascript'
  end

  def at(klass, attribute, options = {})
    klass.human_attribute_name(attribute.to_s, options = {})
  end

  def openid_link
    link_to at(User, :openid_identifier), "http://openid.net/"
  end

  def obligatorio
    content_tag(:span,' *Obligatorio', :class => 'obligatorio')
  end
  
  def login_form
    controller.controller_name == "user_sessions" and controller.action_name == "new"
  end
end
