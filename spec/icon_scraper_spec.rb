RSpec.describe IconScraper do
  it "has a version number" do
    expect(IconScraper::VERSION).not_to be nil
  end

  describe ".rest_xml", :vcr do
    context "feed without address" do
      it "should not error" do
        IconScraper.rest_xml("http://epb.swan.wa.gov.au/Pages/XC.Track/SearchApplication.aspx", "d=thisweek&k=LodgementDate&t=282,281,283&o=xml")
      end
    end
  end
end
