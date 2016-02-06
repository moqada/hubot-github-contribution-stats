# coffeelint: disable=max_line_length
# Description
#   Notify GitHub Contributions and Streaks.
#
# Commands:
#   hubot ghstats [<name>|"<name1> <name2>..."] [text] - Show user's GitHub contributions and streaks
#   hubot ghstats [<name>|"<name1> <name2>..."] notify [text|only] - Notify user's GitHub contributions
#   hubot ghstats [<name>|"<name1> <name2>..."] notify[:<@user>|:<[@]user>] [text|only] [failed-only:[mention|send]] [good:"<message>"] [bad:"<message>"] - Notify user's GitHub contributions with mention
#   hubot ghstats schedule [add|new] "<pattern>" <command> - Add scheduled job
#   hubot ghstats schedule [edit|update] <id> <command> - Update scheduled job
#   hubot ghstats schedule [cancel|del|delete|remove|rm] <id> - Cancel scheduled job
#   hubot ghstats schedule [ls|list] - List scheduled jobs
#
# Configuration:
#   HUBOT_GITHUB_CONTRIBUTION_STATS_DISABLE_GITHUB_LINK - Set disable GitHub link in message
#   HUBOT_GITHUB_CONTRIBUTION_STATS_ERROR_MESSAGE - Set message for error
#   HUBOT_GITHUB_CONTRIBUTION_STATS_ERROR_MESSAGE_404 - Set message when does not exist GitHub user
#   HUBOT_GITHUB_CONTRIBUTION_STATS_NOTIFY_MESSAGE_GOOD - Set message for notify when has contributions on today
#   HUBOT_GITHUB_CONTRIBUTION_STATS_NOTIFY_MESSAGE_BAD - Set message for notify when does not have contributions on today
#   HUBOT_GITHUB_CONTRIBUTION_STATS_GYAZO_TOKEN - Set Gyazo API Token for upload graph image
#   HUBOT_GITHUB_CONTRIBUTION_STATS_RESEND_GRAPH - Set resending graph image (for HipChat)
#   HUBOT_GITHUB_CONTRIBUTION_STATS_ADD_SCHEDULE_SUCCESS_MESSAGE - Set message when success adding scheduled job
#   HUBOT_GITHUB_CONTRIBUTION_STATS_ADD_SCHEDULE_ERROR_MESSAGE - Set message when error adding scheduled job
#   HUBOT_GITHUB_CONTRIBUTION_STATS_CANCEL_SCHEDULE_SUCCESS_MESSAGE - Set message when success canceling scheduled job
#   HUBOT_GITHUB_CONTRIBUTION_STATS_CANCEL_SCHEDULE_ERROR_MESSAGE - Set message when error canceling scheduled job
#   HUBOT_GITHUB_CONTRIBUTION_STATS_CANCEL_SCHEDULE_NOTFOUND_MESSAGE - Set message when does not exist canceling scheduled job
#   HUBOT_GITHUB_CONTRIBUTION_STATS_LIST_SCHEDULE_EMPTY_MESSAGE - Set message when does not exist scheduled jobs
#   HUBOT_GITHUB_CONTRIBUTION_STATS_UPDATE_SCHEDULE_SUCCESS_MESSAGE - Set message when success updating scheduled job
#   HUBOT_GITHUB_CONTRIBUTION_STATS_UPDATE_SCHEDULE_ERROR_MESSAGE - Set message when error updating scheduled job
#   HUBOT_GITHUB_CONTRIBUTION_STATSUPDATE_SCHEDULE_NOTFOUND_MESSAGE - Set message when does not exist updating scheduled job
#
# Author:
#   moqada <moqada@gmail.com>
fs = require 'fs'
cheerio = require 'cheerio'
Gyazo = require 'gyazo-api'
svg2png = require 'svg2png'
ghstats = require 'github-contribution-stats'
moment = require 'moment'
tempfile = require 'tempfile'
{Scheduler, Job} = require '../scheduler'


PREFIX = 'HUBOT_GITHUB_CONTRIBUTION_STATS_'
DISABLE_GITHUB_LINK = process.env["#{PREFIX}DISABLE_GITHUB_LINK"] or false
GYAZO_TOKEN = process.env["#{PREFIX}GYAZO_TOKEN"]
RESEND_GRAPH = process.env["#{PREFIX}RESEND_GRAPH"]
STORE_KEY = 'hubot-github-contribution-stats:jobs'
NOTIFY_REGEX = '(".+"|\\w+) notify(?:(?:=|:)(?:(?:@|\\[@\\])(\\w+)))?(?: (text|only))?(?: failed-only(?:=|:)(mention|send))?(?: good(?:=|:)"(.+?)")?(?: bad(?:=|:)"(.+?)")?'
SHOW_REGEX = '(".+"|\\w+)(?: (text))?'
MESSAGES =
  error: process.env["#{PREFIX}ERROR_MESSAGE"] or 'Error'
  error404: process.env["#{PREFIX}ERROR_MESSAGE_404"] or 'User does not exist'
  notifyGood: process.env["#{PREFIX}NOTIFY_MESSAGE_GOOD"] or 'Nice Contributions!'
  notifyBad: process.env["#{PREFIX}NOTIFY_MESSAGE_BAD"] or 'No Contributions today...'
  addScheduleSuccess: (
    process.env["#{PREFIX}ADD_SCHEDULE_SUCCESS_MESSAGE"] or 'Scheduled ghstats task created.'
  )
  addScheduleError: (
    process.env["#{PREFIX}ADD_SCHEDULE_ERROR_MESSAGE"] or 'Scheduled ghstats task could not create.'
  )
  cancelScheduleSuccess: (
    process.env["#{PREFIX}CANCEL_SCHEDULE_SUCCESS_MESSAGE"] or 'Scheduled ghstats task canceld.'
  )
  cancelScheduleError: (
    process.env["#{PREFIX}CANCEL_SCHEDULE_ERROR_MESSAGE"] or 'Scheduled ghstats task could not cancel.'
  )
  cancelScheduleNotfound: (
    process.env["#{PREFIX}CANCEL_SCHEDULE_NOTFOUND_MESSAGE"] or 'Scheduled ghstats task does not exists.'
  )
  listScheduleEmpty: (
    process.env["#{PREFIX}LIST_SCHEDULE_EMPTY_MESSAGE"] or 'Schedule tasks does not exists.'
  )
  updateScheduleSuccess: (
    process.env["#{PREFIX}UPDATE_SCHEDULE_SUCCESS_MESSAGE"] or 'Scheduled ghstats task updated.'
  )
  updateScheduleError: (
    process.env["#{PREFIX}UPDATE_SCHEDULE_ERROR_MESSAGE"] or 'Scheduled ghstats task could not update.'
  )
  updateScheduleNotfound: (
    process.env["#{PREFIX}UPDATE_SCHEDULE_NOTFOUND_MESSAGE"] or 'Scheduled ghstats task does not exists.'
  )

module.exports = (robot) ->

  scheduler = new Scheduler(robot, STORE_KEY, GHJob)

  robot.respond new RegExp("ghstats #{SHOW_REGEX}$", 'i'), (res) ->
    {usernames, options} = parseShowArgs res.match.slice(1)
    show res, usernames, options

  robot.respond new RegExp("ghstats #{NOTIFY_REGEX}$", 'i'), (res) ->
    {usernames, options} = parseNotifyArgs res.match.slice(1)
    notify res, usernames, options

  robot.respond new RegExp('ghstats schedule (?:add|new) "(.+)" (.+)$', 'i'), (res) ->
    [pattern, source] = res.match.slice(1, 3)
    parsed = parseScheduleArgs source
    if not parsed
      return
    {type, usernames, options} = parsed
    {user} = res.message
    try
      job = scheduler.createJob pattern, user, {type, source, usernames, options}
      res.send "#{job.id}: #{MESSAGES.addScheduleSuccess}"
    catch err
      res.send "#{MESSAGES.addScheduleError} (#{err.message})"
      throw err

  robot.respond new RegExp('ghstats schedule (?:edit|update) (\\d+) (.+)$', 'i'), (res) ->
    [id, source] = res.match.slice(1, 4)
    parsed = parseScheduleArgs source
    if not parsed
      return
    {type, usernames, options} = parsed
    {user} = res.message
    try
      scheduler.updateJob id, {type, source, usernames, options}
      res.send "#{id}: #{MESSAGES.updateScheduleSuccess}"
    catch err
      if err.name is 'JobNotFound'
        return res.send "#{id}: #{MESSAGES.updateScheduleNotfound}"
      res.send "#{MESSAGES.updateScheduleError} (#{err.message})"
      throw err

  robot.respond new RegExp('ghstats schedule (?:cancel|del|delete|remove|rm) (\\w+)$', 'i'), (res) ->
    id = res.match[1]
    try
      scheduler.cancelJob id
      res.send "#{id}: #{MESSAGES.cancelScheduleSuccess}"
    catch err
      if err.name is 'JobNotFound'
        return res.send "#{id}: #{MESSAGES.cancelScheduleNotfound}"
      res.send "#{id}: #{MESSAGES.cancelScheduleError} (#{err.message})"
      throw err

  robot.respond new RegExp('ghstats schedule (?:ls|list)$', 'i'), (res) ->
    msgs = ("#{id}: [#{job.pattern}] ##{job.getRoom()} #{job.meta.source}" for id, job of scheduler.jobs)
    if msgs.length > 0
      return res.send msgs.join '\n'
    res.send MESSAGES.listScheduleEmpty


parseShowArgs = (matches) ->
  [usernames, display] = matches
  options = {display}
  usernames = parseUsernames usernames
  return {usernames, options}

parseNotifyArgs = (matches) ->
  [usernames, mention, display, failedOnly, msgGood, msgBad] = matches
  options = {failedOnly, display, mention, msgGood, msgBad}
  usernames = parseUsernames usernames
  return {usernames, options}

parseScheduleArgs = (source) ->
  type = 'notify'
  matches = new RegExp("^#{NOTIFY_REGEX}$", 'i').exec source
  parser = parseNotifyArgs
  if not matches
    matches = new RegExp("^#{SHOW_REGEX}$", 'i').exec source
    if not matches
      return
    parser = parseShowArgs
    type = 'show'
  {usernames, options} = parser matches.slice(1)
  return {usernames, options, type}

parseUsernames = (string) ->
  string.replace(/"/g, '').split(' ').filter (s) -> s


show = (sender, usernames, opts) ->
  promise = Promise.resolve()
  usernames.forEach (username) ->
    promise = promise.then -> showStats sender, username, opts

notify = (sender, usernames, opts) ->
  promise = Promise.resolve()
  usernames.forEach (username) ->
    promise = promise.then -> notifyStats sender, username, opts

showStats = (sender, username, opts) ->
  hasGraph = opts.display isnt 'text'
  ghstats.fetchStats(username)
    .then (stats) ->
      if not hasGraph
        return {stats: stats, image: null}
      return createGraphUrl(stats).then (image) -> {stats: stats, image: image}
    .then (ctx) ->
      return Object.assign
        message: createCommonMessage username, ctx.stats, ctx.image
    .then (ctx) ->
      sender.send ctx.message
      if hasGraph and RESEND_GRAPH
        return resendGraph sender, ctx.image
    .catch (err) ->
      console.error err
      if err.message is 'USER_NOT_FOUND'
        msg = MESSAGES.error404
      else
        msg = MESSAGES.error
      sender.send msg


notifyStats = (sender, username, opts) ->
  hasGraph = opts.display not in ['text', 'only']
  {mention, msgGood, msgBad} = opts
  ghstats.fetchStats(username)
    .then (stats) ->
      if not hasGraph
        return {stats, image: null}
      return createGraphUrl(stats).then (image) -> {stats, image}
    .then (ctx) ->
      if opts.display is 'only'
        return Object.assign {}, ctx, message: ''
      return Object.assign {}, ctx,
        message: createCommonMessage username, ctx.stats, ctx.image
    .then (ctx) ->
      isGood = hasContributionsToday ctx.stats
      msg = if isGood then msgGood or MESSAGES.notifyGood else msgBad or MESSAGES.notifyBad
      if ctx.message
        msg = """
        #{msg}

        #{ctx.message}
        """
      if mention and (opts.failedOnly isnt 'mention' or not isGood)
        msg = "@#{mention} #{msg}"
      if opts.failedOnly isnt 'send' or not isGood
        sender.send msg
        if hasGraph and RESEND_GRAPH
          return resendGraph sender.send, ctx.image
    .catch (err) ->
      console.error err
      if err.message is 'USER_NOT_FOUND'
        msg = MESSAGES.error404
      else
        msg = MESSAGES.error
      if mention
        msg = "@#{mention} #{msg}"
      sender.send msg


resendGraph = (sender, image) ->
  new Promise (resolve) ->
    setTimeout ->
      resolve sender.send image
    , 500


createGraphUrl = (stats) ->
  if GYAZO_TOKEN
    return uploadImage(stats)
  Promise.resolve null


createCommonMessage = (username, stats, image) ->
  msg = formatStats stats
  if not DISABLE_GITHUB_LINK
    msg = """
    https://github.com/#{username}
    #{msg}
    """
  if image
    msg = """
    #{msg}
    #{image}
    """
  return msg


hasContributionsToday = (stats) ->
  current = stats.contributions.slice(-1)[0]
  today = moment().startOf 'day'
  return not (moment(current.date).diff(today) < 0 or current.count is 0)


formatStats = (stats) ->
  summary = stats.summary
  cStreak = stats.currentStreak
  lStreak = stats.longestStreak
  fmtD = (date) ->
    moment(date).format 'YYYY-MM-DD'
  cStreakRow = "Current Streak: #{cStreak.days} days"
  lStreakRow = "Longest Streak: #{lStreak.days} days"
  if cStreak.days > 0
    cStreakRow += " (#{fmtD(cStreak.start)} - #{fmtD(cStreak.end)})"
  if lStreak.days > 0
    lStreakRow += " (#{fmtD(lStreak.start)} - #{fmtD(lStreak.end)})"
  """
  Contributions: #{summary.total} (#{fmtD(summary.start)} - #{fmtD(summary.end)})
  #{lStreakRow}
  #{cStreakRow}
  """


uploadImage = (stats) ->
  $cal = cheerio stats.calendar
  $cal.attr 'xmlns', 'http://www.w3.org/2000/svg'
  $cal.find('text').remove()
  width = $cal.attr 'width'
  height = $cal.attr 'height'
  png = svg2png.sync new Buffer($cal.toString()), {width: width, height: height}
  tempPath = tempfile('.png')
  fs.writeFileSync(tempPath, png)
  gyazo = new Gyazo(GYAZO_TOKEN)
  gyazo.upload fs.createReadStream(tempPath)
    .then (res) ->
      fs.unlinkSync tempPath
      res.data.url
    .catch (err) ->
      fs.unlinkSync tempPath
      throw err


class GHJob extends Job

  exec: (robot) ->
    envelope = user: @user, room: @getRoom()
    sender =
      send: (msg) ->
        robot.send envelope, msg
      reply: (msg) ->
        robot.reply envelope, msg
    if @meta.type is 'show'
      func = show
    else if @meta.type is 'notify'
      func = notify
    {usernames, options} = @meta
    func sender, usernames, options
