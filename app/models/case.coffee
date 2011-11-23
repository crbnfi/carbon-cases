Spine = require('spine')

class Case extends Spine.Model
  @configure 'Case', 'title', 'thumbnail'
  
module.exports = Case
