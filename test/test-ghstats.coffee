Helper = require 'hubot-test-helper'
assert = require 'power-assert'

describe 'ghstats', ->
  room = null

  beforeEach ->
    helper = new Helper('../src/scripts/ghstats.coffee')
    room = helper.createRoom()

  afterEach ->
    room.destroy()

  it 'help', ->
    helps = room.robot.helpCommands()
    assert.deepEqual helps, [
      'hubot ghstats <username> [text] - Show user\'s GitHub contributions and streaks'
      'hubot ghstats <username> notify <@user> [text|only] - Notify user\'s GitHub contributions with mention'
      'hubot ghstats <username> notify [text|only] - Notify user\'s GitHub contributions'
    ]
