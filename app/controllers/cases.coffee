Spine   = require('spine')
{Panel} = require('spine.mobile')

CasesView = require('controllers/cases.view')

Case = require('models/case')

class Cases extends Panel

  className: 'cases'

  title: 'Cases'

  elements:
    '.cases-list': 'list'

  events:
    'tap .cases-list > div': 'view'
  
  constructor: ->
    super()

    @html require('views/cases') @
    
    @casesView = new CasesView @

    # Prevent scrolling
    @el.bind 'touchmove', (e) -> e.preventDefault()

    Case.bind 'change refresh', @render

  render: =>
    # Render all case thumbnails to list element
    @list.html require('views/cases.thumbnail') Case.all()
  
  view: (e) ->
    @log "Viewing case..."
    @casesView.render( $(e.currentTarget).item() ).active
      trans: 'right'
      fade: false
    
module.exports = Cases
