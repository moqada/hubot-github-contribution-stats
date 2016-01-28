# coffeelint: disable=max_line_length
# Description
#   Notify GitHub Contributions and Streaks.
#
# Commands:
#   hubot ghstats [<name>|"<name1> <name2>..."] [text] - Show user's GitHub contributions and streaks
#   hubot ghstats [<name>|"<name1> <name2>..."] notify [text|only] - Notify user's GitHub contributions
#   hubot ghstats [<name>|"<name1> <name2>..."] notify [<@user>|<[@]user>] [text|only] [failed-only] - Notify user's GitHub contributions with mention
#
# Configuration:
#   HUBOT_GITHUB_CONTRIBUTION_STATS_DISABLE_GITHUB_LINK - Set disable GitHub link in message
#   HUBOT_GITHUB_CONTRIBUTION_STATS_ERROR_MESSAGE - Set message for error
#   HUBOT_GITHUB_CONTRIBUTION_STATS_ERROR_MESSAGE_404 - Set message when does not exist GitHub user
#   HUBOT_GITHUB_CONTRIBUTION_STATS_NOTIFY_MESSAGE_GOOD - Set message for notify when has contributions on today
#   HUBOT_GITHUB_CONTRIBUTION_STATS_NOTIFY_MESSAGE_BAD - Set message for notify when does not have contributions on today
#   HUBOT_GITHUB_CONTRIBUTION_STATS_GYAZO_TOKEN - Set Gyazo API Token for upload graph image
#   HUBOT_GITHUB_CONTRIBUTION_STATS_RESEND_GRAPH - Set resending graph image (for HipChat)
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

PREFIX = 'HUBOT_GITHUB_CONTRIBUTION_STATS_'
DISABLE_GITHUB_LINK = process.env["#{PREFIX}DISABLE_GITHUB_LINK"] or false
ERROR_MESSAGE = process.env["#{PREFIX}ERROR_MESSAGE"] or 'Error'
ERROR_MESSAGE_404 = (
  process.env["#{PREFIX}ERROR_MESSAGE_404"] or 'User does not exist'
)
NOTIFY_MESSAGE_GOOD = (
  process.env["#{PREFIX}NOTIFY_MESSAGE_GOOD"] or 'Nice Contributions!'
)
NOTIFY_MESSAGE_BAD = (
  process.env["#{PREFIX}NOTIFY_MESSAGE_BAD"] or 'No Contributions today...'
)
GYAZO_TOKEN = process.env["#{PREFIX}GYAZO_TOKEN"]
RESEND_GRAPH = process.env["#{PREFIX}RESEND_GRAPH"]

NOTIFY_REGEX = '(".+"|\\w+) notify(?: (?:(?:@|\\[@\\])(\\w+)))?(?: (text|only))?(?: (failed-only))?'
SHOW_REGEX = '(".+"|\\w+)(?: (text))?'


module.exports = (robot) ->

  robot.respond new RegExp("ghstats #{SHOW_REGEX}$", 'i'), (res) ->
    usernames = parseUsernames res.match[1]
    opts = {display: res.match[2]}
    promise = Promise.resolve()
    usernames.forEach (username) ->
      promise = promise.then -> showStats res, username, opts

  robot.respond new RegExp("ghstats #{NOTIFY_REGEX}$", 'i'), (res) ->
    [usernames, mention, display, failedOnly] = res.match.slice(1)
    opts = {failedOnly: failedOnly, display: display}
    usernames = parseUsernames usernames
    promise = Promise.resolve()
    usernames.forEach (username) ->
      promise = promise.then -> notifyStats res, username, mention, opts


parseUsernames = (string) ->
  string.replace(/"/g, '').split(' ').filter (s) -> s


showStats = (res, username, opts) ->
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
      res.send ctx.message
      if hasGraph and RESEND_GRAPH
        return resendGraph res, ctx.image
    .catch (err) ->
      console.error err
      if err.message is 'USER_NOT_FOUND'
        msg = ERROR_MESSAGE_404
      else
        msg = ERROR_MESSAGE
      res.send msg


notifyStats = (res, username, mention, opts) ->
  hasGraph = opts.display not in ['text', 'only']
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
      msg = if isGood then NOTIFY_MESSAGE_GOOD else NOTIFY_MESSAGE_BAD
      if ctx.message
        msg = """
        #{msg}

        #{ctx.message}
        """
      if mention and (not opts.failedOnly or not isGood)
        msg = "@#{mention} #{msg}"
      res.send msg
      if hasGraph and RESEND_GRAPH
        return resendGraph res, ctx.image
    .catch (err) ->
      console.error err
      if err.message is 'USER_NOT_FOUND'
        msg = ERROR_MESSAGE_404
      else
        msg = ERROR_MESSAGE
      if mention
        msg = "@#{mention} #{msg}"
      res.send msg


resendGraph = (res, image) ->
  new Promise (resolve) ->
    setTimeout ->
      resolve res.send image
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
