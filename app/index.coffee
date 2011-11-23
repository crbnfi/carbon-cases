require('lib/setup')

Spine   = require('spine')
{Stage} = require('spine.mobile')

Cases = require('controllers/cases')

Case = require('models/case')

class App extends Stage.Global
  constructor: ->
    super

    # Activate cases controller
    @cases = new Cases
    @cases.active()

    # Disable click events
    #$('body').bind 'click', (e) -> 
    #  e.preventDefault()

    # Orientation change
    $('body').bind 'orientationchange', (e) ->
      orientation = if Math.abs(window.orientation) is 90 then 'landscape' else 'portrait'
      $('body').removeClass('portrait landscape')
               .addClass(orientation)
               .trigger('turn', orientation: orientation)
    
    # Populate cases
    Case.refresh [
      title: 'Stora Enso'
      thumbnail: 'portfolio-storaenso-2.png'
      images: [
        { source: 'portfolio-storaenso-1.png', description: 'Stora Enso' },
        { source: 'portfolio-storaenso-2.png', description: 'Stora Enso' },
        { source: 'portfolio-storaenso-3.png', description: 'Stora Enso' },
        { source: 'portfolio-storaenso-4.png', description: 'Stora Enso' },
        { source: 'portfolio-storaenso-5.png', description: 'Stora Enso' }
      ]
    ,
      title: 'Laastari'
      thumbnail: 'laastari-1.png'
      images: [
        { source: 'laastari-1.png', description: 'Laastari' },
        { source: 'laastari-2.png', description: 'Laastari' },
        { source: 'laastari-3.png', description: 'Laastari' },
      ]
    ,
      title: 'SON Helsinki'
      thumbnail: 'son-1.png'
      images: [
        { source: 'son-1.png', description: 'SON Helsinki' },
        { source: 'son-2.png', description: 'SON Helsinki' },
        { source: 'son-3.png', description: 'SON Helsinki' },
        { source: 'son-4.png', description: 'SON Helsinki' }
      ]
    ,
      title: 'Band Of Monkeys'
      thumbnail: 'bom-1.png'
      images: [
        { source: 'bom-1.png', description: 'Band Of Monkeys - iPad applikaatio' },
        { source: 'bom-2.png', description: 'Band Of Monkeys - iPad applikaatio' },
        { source: 'bom-3.png', description: 'Band Of Monkeys - iPad applikaatio' },
        { source: 'bom-4.png', description: 'Band Of Monkeys - iPad applikaatio' },
        { source: 'bom-5.png', description: 'Band Of Monkeys - iPad applikaatio' }
      ]
    ,
      title: 'Enervit'
      thumbnail: 'enervit-1.png'
      images: [
        { source: 'enervit-1.png', description: 'Enervit - iPad applikaatio' },
        { source: 'enervit-2.png', description: 'Enervit - iPad applikaatio' },
        { source: 'enervit-3.png', description: 'Enervit - iPad applikaatio' },
        { source: 'enervit-4.png', description: 'Enervit - iPad applikaatio' }
      ]
    ,
      title: 'F-Secure'
      thumbnail: 'fsecure-1.png'
      images: [
        { source: 'fsecure-1.png', description: 'F-Secure' },
        { source: 'fsecure-2.png', description: 'F-Secure' },
      ]
    ,
    #  title: 'DNA Täysturva'
    #  thumbnail: 'dna-taysturva.png'
    #  images: [
    #    { source: 'dna-1.png', description: 'DNA Täysturva' },
    #    { source: 'dna-2.png', description: 'DNA Täysturva' },
    #  ]
    #,
    ]

module.exports = App
