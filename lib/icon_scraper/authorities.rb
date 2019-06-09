# frozen_string_literal: true

module IconScraper
  AUTHORITIES = {
    gosford: {
      url: "https://plan.gosford.nsw.gov.au/Pages",
      period: "last14days"
    },
    cumberland: {
      url: "http://eplanning.cumberland.nsw.gov.au/Pages",
      period: "last14days"
    },
    coffs_harbour: {
      url: "https://planningexchange.coffsharbour.nsw.gov.au/PortalProd/Pages",
      period: "last14days",
      ssl_verify: false
    },
    blue_mountains: {
      url: "https://www2.bmcc.nsw.gov.au/DATracking/Pages",
      period: "last14days"
    },
    swan: {
      url: "https://elodge.swan.wa.gov.au/Pages",
      types: [282, 281, 283],
      period: "thisweek"
    },
    gosnells: {
      url: "http://apps.gosnells.wa.gov.au/ICON/Pages",
      period: "last14days"
    },
    greater_taree: {
      url: "http://icon.gtcc.nsw.gov.au/eplanning/Pages",
      period: "last14days",
      types: [290]
    },
    hobart: {
      url: "https://apply.hobartcity.com.au/Pages",
      period: "last14days",
      types: ["PLN"]
    },
    hornsby: {
      url: "http://hscenquiry.hornsby.nsw.gov.au/Pages",
      period: "last14days"
    },
    leichhardt: {
      url: "http://www.eservices.lmc.nsw.gov.au/ApplicationTracking/Pages",
      period: "last14days",
      types: [161]
    },
    liverpool: {
      url: "https://eplanning.liverpool.nsw.gov.au/Pages",
      period: "last14days"
    },
    mosman: {
      url: "http://portal.mosman.nsw.gov.au/Pages",
      period: "last14days",
      types: [8, 5]
    },
    north_sydney: {
      url: "https://apptracking.northsydney.nsw.gov.au/Pages",
      period: "last14days"
    },
    northern_beaches: {
      url: "https://eservices.northernbeaches.nsw.gov.au/ePlanning/live/Public",
      period: "last14days",
      types: ["DevApp"]
    }
  }.freeze
end
