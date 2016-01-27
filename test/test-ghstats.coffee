# coffeelint: disable=max_line_length
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
      'hubot ghstats [<name>|"<name1> <name2>..."] [text] - Show user\'s GitHub contributions and streaks'
      'hubot ghstats [<name>|"<name1> <name2>..."] notify [<@user>|<[@]user>] [text|only] [failed-only] - Notify user\'s GitHub contributions with mention'
      'hubot ghstats [<name>|"<name1> <name2>..."] notify [text|only] - Notify user\'s GitHub contributions'
    ]
