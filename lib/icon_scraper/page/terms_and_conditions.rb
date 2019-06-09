# frozen_string_literal: true

module IconScraper
  module Page
    # The page which pops annoyingly for you to agree to some arbitrary terms and conditions
    module TermsAndConditions
      def self.agree(doc)
        button = agree_button(doc)
        raise "Can't find agree button" if button.nil?

        doc.form.submit(button)
      end

      # See if we're actually on this page
      def self.on?(doc)
        !agree_button(doc).nil?
      end

      def self.agree_button(doc)
        doc.form.button_with(value: /Agree/)
      end
    end
  end
end
