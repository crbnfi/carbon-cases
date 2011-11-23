Spine   = require('spine')
{Panel} = require('spine.mobile')

Case = require('models/case')

class CasesView extends Panel
  className: 'casesView'

  elements:
    '.images':        'container'
    '.images ul':     'images'
    '.images ul li':  'item'
  
  speed: 300
  index: 0
  length: 0

  constructor: (@controller) ->
    super()

    # Buttons
    @addButton 'Back', (args) =>
      @back()
    
    @addButton 'Prev', @prev
    @addButton 'Next', @next

    $('body').bind 'orientationchange', (e) =>
      @setup

  render: (@case) ->
    @index = 0
    @length = 0
    @setTitle @case.title or 'Case'
    @html require('views/cases.view') @case
    @
  
  setup: ->
    @log "Setup"
    @length = @images.children().length;
    return unless @length > 1

    @width = @el.width();

    @container.css 
      overflow: 'hidden'
      visibility: 'hidden'
    
    #@images.css
    #  '-webkit-backface-visibility': 'hidden'

    @images.width(@width * @length)

    for image in @images.children()
      $(image).css
        width: @width
        display: 'block'
        float: 'left'
    
    @images.unbind().bind
      'touchstart':          @touchstart
      'touchmove':           @touchmove
      'touchend':            @touchend
      'gesturestart':        @gesturestart
      'gesturechange':       @gesturechange
      'gestureend':          @gestureend
      'webkitTransitionEnd': @transitionEnd
    
    @item.unbind().bind
      'tap': @tap

    @slide @index, 0
    
    @container.css visibility: 'visible'

  slide: (index, duration) =>
    duration ?= @speed

    # Hide visible descriptions
    $('.description:visible', @images).hide();

    @images.css
      '-webkit-transition-duration': duration + 'ms'
      '-webkit-transform': 'translate3d(' + -(index * @width) + 'px, 0, 0)'

    @transitionEnd(null) if duration is 0

    @index = index;
  
  next: ->
    @slide if @index < @length - 1 then @index + 1 else 0
  
  prev: ->
    @slide if @index > 0 then @index - 1 else @length - 1

  activate: (params) ->
    super(params)
    @setup()

  back: (trans = { trans: 'left' }) ->
    @controller.active trans

  tap: (e) =>
    $('.description', e.currentTarget).not(':visible').gfxFadeIn(duration: 250);

  touchstart: (e) =>
    e = e.originalEvent

    $('.description:visible', @images).hide();

    @start =
      pageX: e.touches[0].pageX
      pageY: e.touches[0].pageY
      time:  Number( new Date() )

    @isScrolling = undefined;
    @deltaX = 0;

    @images.css '-webkit-transition-duration': 0 + 'ms'

  touchmove: (e) =>
    e = e.originalEvent

    return if e.touches.length > 1 or e.scale and e.scale isnt 1;

    @deltaX = e.touches[0].pageX - @start.pageX;

    # determine if scrolling test has run - one time test
    @isScrolling = !!( this.isScrolling or Math.abs(this.deltaX) < Math.abs(e.touches[0].pageY - this.start.pageY) - 5 ) unless @isScrolling

    # if user is not trying to scroll vertically
    return if @isScrolling

    # prevent native scrolling
    e.preventDefault()

    # increase resistance if first or last slide
    #@deltaX = @deltaX / ( (!@index && @deltaX > 0 || @index == @length - 1 && @deltaX < 0 ) ? ( Math.abs(@deltaX) / @width + 1 ) : 1 );
    @deltaX = @deltaX / ( Math.abs(@deltaX) / @width + 1 ) if (!@index and @deltaX > 0) or (@index == @length - 1 and @deltaX < 0)

    # translate immediately 1-to-1
    @images.css '-webkit-transform': 'translate3d(' + (@deltaX - @index * @width) + 'px, 0, 0)'

  touchend: (e) =>
    e = e.originalEvent

    # determine if slide attempt triggers next/prev slide
    # if slide duration is less than 250ms
    # and if slide amt is greater than 20px
    # or if slide amt is greater than half the width
    isValidSlide = (Number(new Date()) - @start.time < 450 and Math.abs(@deltaX) > 20) or Math.abs(@deltaX) > @width/2           

    # determine if slide attempt is past start and end
    # if first slide and slide amt is greater than 0
    # or if last slide and slide amt is less than 0
    isPastBounds = (!@index and @deltaX > 0) or (@index is @length - 1 and @deltaX < 0)

    # if not scrolling vertically, call slide function with slide end value based on isValidSlide and isPastBounds tests
    to = @index + if isValidSlide and not isPastBounds then (if @deltaX < 0 then 1 else -1) else 0
    @slide( to ) unless @isScrolling
  
  gesturestart: (e) =>
    e = e.originalEvent
    e.preventDefault()
    @gesture ?= {}

  gesturechange: (e) =>
    e = e.originalEvent
    e.preventDefault()
    @gesture.scale = e.scale
  
  gestureend: (e) =>
    e = e.originalEvent
    e.preventDefault()
    @back trans: 'fade' if @gesture.scale < 1

  transitionEnd: (e) =>
    #@log "End"

    
module.exports = CasesView
