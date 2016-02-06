schedule = require 'node-schedule'
cronParser = require 'cron-parser'

difference = (obj1 = {}, obj2 = {}) ->
  diff = {}
  for id, job of obj1
    diff[id] = job if id !of obj2
  return diff

isCronPattern = (pattern) ->
  errors = cronParser.parseString(pattern).errors
  return not Object.keys(errors).length

getPatternType = (pattern) ->
  if isCronPattern pattern
    return 'cron'
  date = Date.parse pattern
  if not isNaN(date)
    if date < Date.now()
      throw new AlreadyPassedPattern()
    return 'date'
  throw new InvalidPattern()


class JobNotFound extends Error
  constructor: (@message = 'Job ID does not exists.') ->
    @name = 'JobNotFound'


class InvalidPattern extends Error
  constructor: (@message = 'Invalid pattern.') ->
    @name = 'InvalidPattern'


class AlreadyPassedPattern extends Error
  constructor: (@message = 'Pattern date already passed.') ->
    @name = 'AlreadyPassedPattern'


class Scheduler
  constructor: (@robot, @storeKey, @JobCls, opts = {}) ->
    @jobs = {}
    {jobMaxCount} = opts
    @jobMaxCount = jobMaxCount or 10000
    @robot.brain.on 'loaded', => @syncBrain()
    @initBrain()

  initBrain: ->
    if not @robot.brain.get @storeKey
      @robot.brain.set @storeKey, {}

  cancelJob: (id) ->
    job = @jobs[id]
    if not job
      throw new JobNotFound()
    job.cancel()
    delete @jobs[id]
    delete @robot.brain.get(@storeKey)[id]

  createJob: (pattern, user, meta, {id} = {}) ->
    if not id
      id = Math.floor(Math.random() * @jobMaxCount) while not id? or @jobs[id]
    patternType = getPatternType pattern
    if patternType is 'cron'
      job = @createCronJob pattern, user, meta, id
    else
      job = @createDateJob pattern, user, meta, id
    job.start @robot
    @jobs[id] = job
    @robot.brain.get(@storeKey)[id] = job.serialize()
    return job

  createCronJob: (pattern, user, meta, id) ->
    new @JobCls id, pattern, user, meta

  createDateJob: (pattern, user, meta, id) ->
    new @JobCls id, new Date(pattern), user, meta, =>
      delete @jobs[id]
      delete @robot.brain.get(@storeKey)[id]

  createJobFromBrain: (id, data) ->
    {pattern, user, meta} = data
    createJob pattern, user, meta, {id}

  storeJobToBrain: (id, job) ->
    @robot.brain.get(@storeKey)[id] = job.serialize()

  syncBrain: ->
    @initBrain()
    nonCachedJobs = difference @robot.brain.get(@storeKey), @jobs
    for own id, jobData of nonCachedJobs
      @createJobFromBrain id, jobData
    nonStoredJobs = difference @jobs, @robot.brain.get @storeKey
    for own id, job of nonStoredJobs
      @storeJobToBrain id, job

  updateJob: (id, meta) ->
    job = @jobs[id]
    if not job
      throw new JobNotFound()
    job.meta = meta
    @robot.brain.get(@storeKey)[id] = job.serialize()


class Job
  constructor: (@id, @pattern, user, @meta, @cb) ->
    @job
    @user = {}
    @user[k] = v for k, v of user

  createExec: (robot) ->
    # ex.
    #
    # ```
    # envelope = user: @user, room: @getRoom()
    # {message} = @meta
    # return -> robot.send envelope, message
    # ```
    throw new Error('NotImplemented')

  getRoom: ->
    @user.room or @user.reply_to

  start: (robot) ->
    exec = @createExec robot
    @job = schedule.scheduleJob @pattern, =>
      exec()
      @cb?()

  cancel: ->
    if @job
      @job.cancel()
    @cb?()

  serialize: ->
    pattern: @pattern
    meta: @meta
    user: @user


module.exports = {Scheduler, Job}
