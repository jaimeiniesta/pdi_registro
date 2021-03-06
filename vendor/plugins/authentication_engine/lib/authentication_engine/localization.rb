module AuthenticationEngine
  module Localization
    module ClassMethods

    end

    module InstanceMethods
      def languages_available
        #@languages_available ||= I18n.load_path.collect do |locale_file|
        #  File.basename(File.basename(locale_file, '.rb'), '.yml')
        #end.uniq.sort
        @languages_available ||= [["Español", "es"]]
      end

      def set_language(prefered = nil)
        session[:language] = prefered unless prefered.blank?
        I18n.locale = session[:language] || cookies[:language] || browser_language || I18n.default_locale || 'en'
      end

      private

      def set_localization
        languages_available
        persist_language
        set_language
        set_time_zone
        set_will_paginate_string
      end

      # browser must accept cookies
      def persist_language
        if !params[:language].blank?
          session[:language] = cookies[:language] = params[:language]
        elsif (session[:language].blank? or cookies[:language].blank?) && !user_language.blank?
          session[:language] = cookies[:language] = user_language
        elsif !browser_language.blank?
          cookies[:language] = browser_language
        end
      end

      def user_language
        return unless current_user && current_user.preference && !current_user.preference.language.blank?
        current_user.preference.language
      end

      def browser_language
        return unless http_lang = request.env["HTTP_ACCEPT_LANGUAGE"] and !http_lang.blank?
        prefix, suffix = http_lang[/^[a-z]{2}/i], http_lang[3,2]
        return unless prefix
        browser_locale = prefix.downcase
        browser_locale << '-' + suffix.upcase if suffix
        browser_locale.sub!(/-US/, '')
        languages_available.flatten.include?(browser_locale) ? browser_locale : nil
      end

      def set_time_zone
        return unless current_user && current_user.preference && !current_user.preference.time_zone.blank?
        Time.zone = current_user.preference.time_zone
      end

      # Because I18n.locale are dynamically determined in ApplicationController,
      # it should not put in config/initializers/will_paginate.rb
      def set_will_paginate_string
        return unless defined? WillPaginate
        WillPaginate::ViewHelpers.pagination_options[:previous_label] = "&laquo; Página anterior"
        WillPaginate::ViewHelpers.pagination_options[:next_label] = "Siguiente página &raquo;"
      end
    end

    def self.included(receiver)
      receiver.extend ClassMethods
      receiver.send :include, InstanceMethods
      receiver.class_eval do
        before_filter :set_localization
        helper_method :languages_available
      end
    end
  end
end