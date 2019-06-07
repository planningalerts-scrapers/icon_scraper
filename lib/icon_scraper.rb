require "icon_scraper/version"

require "mechanize"
require "scraperwiki"

module IconScraper
  def self.scrape_and_save(authority)
    if authority == :blue_mountains
      starting_url = "https://www2.bmcc.nsw.gov.au/DATracking/Pages/XC.Track/SearchApplication.aspx"

      agent = Mechanize.new

      doc = agent.get(starting_url)
      form = doc.forms.first
      button = form.button_with(value: "I Agree")
      raise "Can't find agree button" if button.nil?
      doc = form.submit(button)

      rest_xml(
        starting_url,
        "d=last14days&k=LodgementDate&o=xml",
        false,
        agent
      )
    else
      raise "Unexpected authority: #{authority}"
    end
  end

  # Copied from lib_icon_rest_xml repo
  def self.rest_xml(base_url, query, debug = false, agent = nil)
    agent = Mechanize.new unless agent
    page = agent.get("#{base_url}?#{query}")

    # Explicitly interpret as XML
    page = Nokogiri::XML(page.content)

    raise "Can't find any <Application> elements" unless page.search('Application').length > 0

    page.search('Application').each do |application|
      council_reference = application.at("ReferenceNumber").inner_text

      unless application.at("Address Line1")
        puts "Skipping due to lack of address for #{council_reference}"
        next
      end
      application_id = application.at("ApplicationId").inner_text
      info_url = "#{base_url}?id=#{application_id}"

      address = clean_whitespace(application.at("Address Line1").inner_text)
      if !application.at('Address Line2').inner_text.empty?
        address += ", " + clean_whitespace(application.at("Address Line2").inner_text)
      end

      if application.at("ApplicationDetails")
        description = application.at("ApplicationDetails")
      else
        description = application.at("SubNatureOfApplication")
      end

      unless description
        puts "Skipping due to lack of description for #{council_reference}"
        next
      end

      record = {
        "council_reference" => council_reference,
        "description" => description.inner_text,
        "date_received" => Date.parse(application.at("LodgementDate").inner_text).to_s,
        # TODO: There can be multiple addresses per application
        # We can't just create a new application for each address as we would then have multiple applications
        # with the same council_reference which isn't currently allowed.
        "address" => address,
        "date_scraped" => Date.today.to_s,
        "info_url" => info_url
      }
      # DA03NY1 appears to be the event code for putting this application on exhibition
      # Commenting this out because I don't know whether this can be applied generally to all
      # councils. It seems likely that the event codes are different in each council
      #e = application.search("Event EventCode").find{|e| e.inner_text.strip == "DA03NY1"}
      #if e
      #  record["on_notice_from"] = Date.parse(e.parent.at("LodgementDate").inner_text).to_s
      #  record["on_notice_to"] = Date.parse(e.parent.at("DateDue").inner_text).to_s
      #end

      if debug
        p record
      else
        ScraperWiki.save_sqlite(['council_reference'], record)
      end
    end
  end

  # Copied from lib_icon_rest_xml repo
  def self.clean_whitespace(string)
    string.gsub("\r", ' ').gsub("\n", ' ').squeeze(" ").strip
  end
end
