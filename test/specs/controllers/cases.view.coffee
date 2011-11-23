describe 'Cases.view', ->
  Cases.view = null
  
  beforeEach ->
    class Cases.view extends Spine.Controller
  
  it 'can noop', ->
    