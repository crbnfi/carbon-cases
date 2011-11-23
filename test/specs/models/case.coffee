describe 'Case', ->
  Case = null
  
  beforeEach ->
    class Case extends Spine.Model
      @configure 'Case'
  
  it 'can noop', ->
    