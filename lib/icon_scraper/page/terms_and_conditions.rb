module IconScraper
  module Page
    module TermsAndConditions
      def self.agree(doc)
        form = doc.forms.first
        button = form.button_with(value: "I Agree")
        raise "Can't find agree button" if button.nil?
        form.submit(button)
      end

      # See if we're actually on this page
      def self.on?(doc)
        form = doc.forms.first
        button = form.button_with(value: "I Agree")
        !button.nil?
      end
    end
  end
end
