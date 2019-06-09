# frozen_string_literal: true

module IconScraper
  AUTHORITIES = {
    gosford: {
      url: "https://plan.gosford.nsw.gov.au",
      period: "last14days"
    },
    cumberland: {
      url: "http://eplanning.cumberland.nsw.gov.au",
      period: "last14days"
    },
    coffs_harbour: {
      url: "https://planningexchange.coffsharbour.nsw.gov.au/PortalProd",
      period: "last14days",
      ssl_verify: false
    },
    blue_mountains: {
      url: "https://www2.bmcc.nsw.gov.au/DATracking",
      period: "last14days"
    },
    swan: {
      url: "https://elodge.swan.wa.gov.au",
      types: [282, 281, 283],
      period: "thisweek"
    }
  }.freeze
end
