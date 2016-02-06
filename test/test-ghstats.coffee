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
      'hubot ghstats [<name>|"<name1> <name2>..."] notify [text|only] - Notify user\'s GitHub contributions'
      'hubot ghstats [<name>|"<name1> <name2>..."] notify[:<@user>|:<[@]user>] [text|only] [failed-only:[mention|send]] [good:"<message>"] [bad:"<message>"] - Notify user\'s GitHub contributions with mention'
      'hubot ghstats schedule [add|new] "<pattern>" <command> - Add scheduled job'
      'hubot ghstats schedule [cancel|del|delete|remove|rm] <id> - Cancel scheduled job'
      'hubot ghstats schedule [edit|update] <id> <command> - Update scheduled job'
      'hubot ghstats schedule [ls|list] - List scheduled jobs'
    ]
