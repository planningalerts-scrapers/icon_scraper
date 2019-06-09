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
    },
    gosnells: {
      url: "http://apps.gosnells.wa.gov.au/ICON",
      period: "last14days"
    },
    greater_taree: {
      url: "http://icon.gtcc.nsw.gov.au/eplanning",
      period: "last14days",
      types: [290]
    },
    hobart: {
      url: "https://apply.hobartcity.com.au",
      period: "last14days",
      types: ["PLN"]
    },
    hornsby: {
      url: "http://hscenquiry.hornsby.nsw.gov.au",
      period: "last14days"
    },
    leichhardt: {
      url: "http://www.eservices.lmc.nsw.gov.au/ApplicationTracking",
      period: "last14days",
      types: [161]
    },
    liverpool: {
      url: "https://eplanning.liverpool.nsw.gov.au",
      period: "last14days"
    },
    mosman: {
      url: "http://portal.mosman.nsw.gov.au",
      period: "last14days",
      types: [8, 5]
    },
    north_sydney: {
      url: "https://apptracking.northsydney.nsw.gov.au",
      period: "last14days"
    }
  }.freeze
end
