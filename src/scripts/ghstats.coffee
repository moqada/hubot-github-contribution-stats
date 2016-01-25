# coffeelint: disable=max_line_length
# Description
#   Notify GitHub Contributions and Streaks.
#
# Commands:
#   hubot ghstats <username> [text] - Show user's GitHub contributions and streaks
#   hubot ghstats <username> notify [text|only] - Notify user's GitHub contributions
#   hubot ghstats <username> notify [<@user>|<[@]user>] [text|only] [failed-only] - Notify user's GitHub contributions with mention
#
# Configuration:
#   HUBOT_GITHUB_CONTRIBUTION_STATS_DISABLE_GITHUB_LINK - Set disable GitHub link in message
#   HUBOT_GITHUB_CONTRIBUTION_STATS_ERROR_MESSAGE - Set message for error
#   HUBOT_GITHUB_CONTRIBUTION_STATS_ERROR_MESSAGE_404 - Set message when doesnot exist GitHub user
#   HUBOT_GITHUB_CONTRIBUTION_STATS_NOTIFY_MESSAGE_GOOD - Set message for notify when has contributions on today
#   HUBOT_GITHUB_CONTRIBUTION_STATS_NOTIFY_MESSAGE_BAD - Set message for notify when doesnot have contributions on today
#   HUBOT_GITHUB_CONTRIBUTION_STATS_GYAZO_TOKEN - Set Gyazo API Token for upload graph image
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
  process.env["#{PREFIX}ERROR_MESSAGE_404"] or 'User doesnot exist'
)
NOTIFY_MESSAGE_GOOD = (
  process.env["#{PREFIX}NOTIFY_MESSAGE_GOOD"] or 'Nice Contributions!'
)
NOTIFY_MESSAGE_BAD = (
  process.env["#{PREFIX}NOTIFY_MESSAGE_BAD"] or 'No Contributions today...'
)
GYAZO_TOKEN = process.env["#{PREFIX}GYAZO_TOKEN"]


module.exports = (robot) ->

  robot.respond /ghstats\s+([^\s]+)\s+notify(?:\s+(?:(?:@|\[@\])([^\s]+)))?(?:\s+(text|only))?(?:\s+(failed-only))?$/i, (res) ->
    [username, mention, option, failedOnly] = res.match.slice(1)
    ghstats.fetchStats(username)
      .then (stats) ->
        if option is 'only'
          return {msg: '', stats: stats}
        withGraph = option isnt 'text'
        return getMessage(username, stats, withGraph).then (msg) -> {msg: msg, stats: stats}
      .then (data) ->
        current = data.stats.contributions.slice(-1)[0]
        today = moment().startOf 'day'
        isBad = moment(current.date).diff(today) < 0 or current.count is 0
        if isBad
          msg = """
          #{NOTIFY_MESSAGE_BAD}

          #{data.msg}
          """
        else
          msg = """
          #{NOTIFY_MESSAGE_GOOD}

          #{data.msg}
          """
        failedOnly and isBad
        if mention and (not failedOnly or isBad)
          msg = "@#{mention} #{msg}"
        res.send msg
      .catch (err) ->
        console.error err
        if err.message is 'USER_NOT_FOUND'
          msg = ERROR_MESSAGE_404
        else
          msg = ERROR_MESSAGE
        if mention
          msg = "#{mention} #{msg}"
        res.send msg

  robot.respond /ghstats\s([^\s]+)(?:\s+(text))?$/i, (res) ->
    username = res.match[1]
    withGraph = not res.match[2]
    ghstats.fetchStats(username)
      .then (stats) -> getMessage(username, stats, withGraph)
      .then (msg) -> res.send msg
      .catch (err) ->
        console.error err
        if err.message is 'USER_NOT_FOUND'
          msg = ERROR_MESSAGE_404
        else
          msg = ERROR_MESSAGE
        res.send msg


getMessage = (username, stats, graph) ->
  msg = formatStats stats
  if not DISABLE_GITHUB_LINK
    msg = """
    https://github.com/#{username}
    #{msg}
    """
  if GYAZO_TOKEN and graph
    return uploadImage(stats).then (image) ->
      return """
      #{msg}
      #{image}
      """
  return Promise.resolve msg


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
