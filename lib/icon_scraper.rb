# frozen_string_literal: true

require "icon_scraper/version"
require "icon_scraper/page/terms_and_conditions"
require "icon_scraper/authorities"

require "mechanize"
require "scraperwiki"
require "active_support/core_ext/hash"

# Scrape an icon application development system
module IconScraper
  def self.scrape(authority)
    params = AUTHORITIES[authority]
    raise "Unexpected authority: #{authority}" if params.nil?

    scrape_with_params(params) do |record|
      yield record
    end
  end

  def self.scrape_with_params(url:, period:, types: nil, ssl_verify: true)
    url += "/Pages/XC.Track/SearchApplication.aspx"

    agent = Mechanize.new
    agent.verify_mode = OpenSSL::SSL::VERIFY_NONE unless ssl_verify
    doc = agent.get(url)
    Page::TermsAndConditions.agree(doc) if Page::TermsAndConditions.on?(doc)
    params = { d: period, k: "LodgementDate", o: "xml" }
    params[:t] = types.join(",") if types
    rest_xml(url, params, agent) do |record|
      yield record
    end
  end

  def self.scrape_and_save(authority)
    scrape(authority) do |record|
      save(record)
    end
  end

  def self.rest_xml(base_url, query, agent)
    query = query.to_query
    page = agent.get("#{base_url}?#{query}")

    # Explicitly interpret as XML
    page = Nokogiri::XML(page.content)

    raise "Can't find any <Application> elements" unless page.search("Application").length.positive?

    page.search("Application").each do |application|
      council_reference = application.at("ReferenceNumber").inner_text

      unless application.at("Address Line1")
        puts "Skipping due to lack of address for #{council_reference}"
        next
      end
      application_id = application.at("ApplicationId").inner_text

      # No idea what this means but it's required to calculate the
      # correct info_url
      pprs = application.at("ThePPRS")&.inner_text

      info_url = "#{base_url}?id=#{application_id}"
      info_url += "&pprs=#{pprs}" if pprs

      address = clean_whitespace(application.at("Address Line1").inner_text)
      unless application.at("Address Line2").inner_text.empty?
        address += ", " + clean_whitespace(application.at("Address Line2").inner_text)
      end

      description = application.at("ApplicationDetails") ||
                    application.at("SubNatureOfApplication")

      unless description
        puts "Skipping due to lack of description for #{council_reference}"
        next
      end

      record = {
        "council_reference" => council_reference,
        "description" => description.inner_text,
        "date_received" => Date.parse(application.at("LodgementDate").inner_text).to_s,
        # TODO: There can be multiple addresses per application
        # We can't just create a new application for each address as we would then have multiple
        # applications with the same council_reference which isn't currently allowed.
        "address" => address,
        "date_scraped" => Date.today.to_s,
        "info_url" => info_url
      }
      # DA03NY1 appears to be the event code for putting this application on exhibition
      # Commenting this out because I don't know whether this can be applied generally to all
      # councils. It seems likely that the event codes are different in each council
      # e = application.search("Event EventCode").find{|e| e.inner_text.strip == "DA03NY1"}
      # if e
      #   record["on_notice_from"] = Date.parse(e.parent.at("LodgementDate").inner_text).to_s
      #   record["on_notice_to"] = Date.parse(e.parent.at("DateDue").inner_text).to_s
      # end

      yield record
    end
  end

  def self.save(record)
    log(record)
    ScraperWiki.save_sqlite(["council_reference"], record)
  end

  def self.log(record)
    puts "Storing #{record['council_reference']} - #{record['address']}"
  end

  # Copied from lib_icon_rest_xml repo
  def self.clean_whitespace(string)
    string.gsub("\r", " ").gsub("\n", " ").squeeze(" ").strip
  end
end
