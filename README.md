# hubot-github-contribution-stats

[![NPM version][npm-image]][npm-url]
[![NPM downloads][npm-download-image]][npm-download-url]
[![Build Status][travis-image]][travis-url]
[![Dependency Status][daviddm-image]][daviddm-url]
[![DevDependency Status][daviddm-dev-image]][daviddm-dev-url]
[![License][license-image]][license-url]

Notify GitHub Contributions and Streaks.

:clock2: Support Recurrence and Scheduled notifications.

## Demo

![](https://i.gyazo.com/366b005577de8b37c56d2d33414bb6c0.png)

## Installation

```
npm install hubot-github-contribution-stats --save
```

Then add **hubot-github-contribution-stats** to your `external-scripts.json`:

```json
["hubot-github-contribution-stats"]
```

## Sample Interaction

### Show

Show Contributions and Streaks with graph

```
Hubot> hubot ghstats moqada
Hubot> https://github.com/moqada
Contributions: 1278 (2015-01-23 - 2016-01-23)
Longest Streak: 140 days (2015-09-06 - 2016-01-23)
Current Streak: 140 days (2015-09-06 - 2016-01-23)
https://i.gyazo.com/34d59c9c4d184962420f9a20ba5e5f2a.png
```

Show Contributions and Streaks of multiple users

```
Hubot> hubot ghstats "moqada achiku ideyuta"
Hubot> https://github.com/achiku
Contributions: 694 (2015-01-27 - 2016-01-27)
Longest Streak: 21 days (2015-12-30 - 2016-01-19)
Current Streak: 0 days
https://i.gyazo.com/5834155a2e62558a46af13c0005465a6.png
https://github.com/ideyuta
Contributions: 829 (2015-01-27 - 2016-01-27)
Longest Streak: 23 days (2016-01-05 - 2016-01-27)
Current Streak: 23 days (2016-01-05 - 2016-01-27)
https://i.gyazo.com/4e5dc1a595f9c29e0745d193dc9902fa.png
https://github.com/moqada
Contributions: 1320 (2015-01-27 - 2016-01-27)
Longest Streak: 144 days (2015-09-06 - 2016-01-27)
Current Streak: 144 days (2015-09-06 - 2016-01-27)
https://i.gyazo.com/13f2a364a9871b00d6dddc7d78e8bd62.png
```

Show Contributions and Streaks without graph

```
Hubot> hubot ghstats moqada text
Hubot> https://github.com/moqada
Contributions: 1278 (2015-01-23 - 2016-01-23)
Longest Streak: 140 days (2015-09-06 - 2016-01-23)
Current Streak: 140 days (2015-09-06 - 2016-01-23)
```

### Notification

Notify today's Contributions

```
Hubot> hubot ghstats moqada notify
Hubot> No Contributions today...

https://github.com/moqada
Contributions: 1278 (2015-01-23 - 2016-01-23)
Longest Streak: 140 days (2015-09-06 - 2016-01-23)
Current Streak: 140 days (2015-09-06 - 2016-01-23)
https://i.gyazo.com/34d59c9c4d184962420f9a20ba5e5f2a.png
```

Notify today's Contributions with mention

```
Hubot> hubot ghstats moqada notify:@moqada
Hubot> @moqada No Contributions today...

https://github.com/moqada
Contributions: 1278 (2015-01-23 - 2016-01-23)
Longest Streak: 140 days (2015-09-06 - 2016-01-23)
Current Streak: 140 days (2015-09-06 - 2016-01-23)
https://i.gyazo.com/34d59c9c4d184962420f9a20ba5e5f2a.png
```

Notify today's Contributions with mention only message
```
Hubot> hubot ghstats moqada notify:@moqada only
Hubot> @moqada No Contributions today...
```

Notify today's Contributions with mention without graph
```
Hubot> hubot ghstats moqada notify:@moqada text
Hubot> @moqada No Contributions today...

https://github.com/moqada
Contributions: 1278 (2015-01-23 - 2016-01-23)
Longest Streak: 140 days (2015-09-06 - 2016-01-23)
Current Streak: 140 days (2015-09-06 - 2016-01-23)
```

Notify today's Contributions with mention if user does not have conntributions
```
Hubot> hubot ghstats moqada notify:@moqada failed-only:send
# today's Contributions exists: No send
```

Notify today's Contributions without mention if user have conntributions
```
Hubot> hubot ghstats moqada notify:@moqada failed-only:mention
Hubot> Contributions today...

https://github.com/moqada
Contributions: 1278 (2015-01-23 - 2016-01-23)
Longest Streak: 140 days (2015-09-06 - 2016-01-23)
Current Streak: 140 days (2015-09-06 - 2016-01-23)
```

### Scheduled task

Add Recurrence task by cron fromat. (ex. every 19:00)
```
Hubot> hubot ghstats schedule add "0 19 * * *" moqada notify:@moqada
9999: Scheduled ghstats task created.
```

Add Scheduled task by date fromat. (ex. 2016-02-20 19:00)
```
Hubot> hubot ghstats schedule add "2016-02-20 19:00" moqada notify:@moqada
8888: Scheduled ghstats task created.
```

Update Scheduled task
```
Hubot> hubot ghstats schedule update 9999 achiku notify:@achiku
Hubot> 9999: Scheduled ghstats task updated. 
```

Cancel Scheduled task
```
Hubot> hubot ghstats schedule del 9999
Hubot> 9999: Scheduled ghstats task canceld.
```

List Scheduled tasks
```
Hubot> hubot ghstats schedule ls
2864: [Sat Feb 20 2016 09:00:00 GMT+0900 (JST)] #Shell achiku notify:[@]here
3537: [10/* * * * * *] #Shell moqada notify:[@]moqada failed-only:send bad:"Fuck!!!"
```


## Commands

```
hubot ghstats [<name>|"<name1> <name2>..."] [text] - Show user's GitHub contributions and streaks
hubot ghstats [<name>|"<name1> <name2>..."] notify [text|only] - Notify user's GitHub contributions
hubot ghstats [<name>|"<name1> <name2>..."] notify[:<@user>|:<[@]user>] [text|only] [failed-only:[mention|send]] [good:"<message>"] [bad:"<message>"] - Notify user's GitHub contributions with mention
hubot ghstats schedule [add|new] "<pattern>" <command> - Add scheduled job
hubot ghstats schedule [edit|update] <id> <command> - Update scheduled job
hubot ghstats schedule [cancel|del|delete|remove|rm] <id> - Cancel scheduled job
hubot ghstats schedule [ls|list] - List scheduled jobs
```

## Configurations

```
HUBOT_GITHUB_CONTRIBUTION_STATS_DISABLE_GITHUB_LINK - Set disable GitHub link in message
HUBOT_GITHUB_CONTRIBUTION_STATS_GYAZO_TOKEN - Set Gyazo API Token for upload graph image
HUBOT_GITHUB_CONTRIBUTION_STATS_RESEND_GRAPH - Set resending graph image (for HipChat)
HUBOT_GITHUB_CONTRIBUTION_STATS_ERROR_MESSAGE - Set message for error
HUBOT_GITHUB_CONTRIBUTION_STATS_ERROR_MESSAGE_404 - Set message when does not exist GitHub user
HUBOT_GITHUB_CONTRIBUTION_STATS_NOTIFY_MESSAGE_GOOD - Set message for notify when has contributions on today
HUBOT_GITHUB_CONTRIBUTION_STATS_NOTIFY_MESSAGE_BAD - Set message for notify when does not have contributions on today
HUBOT_GITHUB_CONTRIBUTION_STATS_ADD_SCHEDULE_SUCCESS_MESSAGE - Set message when success adding scheduled job
HUBOT_GITHUB_CONTRIBUTION_STATS_ADD_SCHEDULE_ERROR_MESSAGE - Set message when error adding scheduled job
HUBOT_GITHUB_CONTRIBUTION_STATS_CANCEL_SCHEDULE_SUCCESS_MESSAGE - Set message when success canceling scheduled job
HUBOT_GITHUB_CONTRIBUTION_STATS_CANCEL_SCHEDULE_ERROR_MESSAGE - Set message when error canceling scheduled job
HUBOT_GITHUB_CONTRIBUTION_STATS_CANCEL_SCHEDULE_NOTFOUND_MESSAGE - Set message when does not exist canceling scheduled job
HUBOT_GITHUB_CONTRIBUTION_STATS_LIST_SCHEDULE_EMPTY_MESSAGE - Set message when does not exist scheduled jobs
HUBOT_GITHUB_CONTRIBUTION_STATS_UPDATE_SCHEDULE_SUCCESS_MESSAGE - Set message when success updating scheduled job
HUBOT_GITHUB_CONTRIBUTION_STATS_UPDATE_SCHEDULE_ERROR_MESSAGE - Set message when error updating scheduled job
HUBOT_GITHUB_CONTRIBUTION_STATS_UPDATE_SCHEDULE_NOTFOUND_MESSAGE - Set message when does not exist updating scheduled job
```

## Tips

### Scheduled tasks

If you want to notify every day.
For example, following config is...

- notify every 20 o'clock
- notify only mention at 21 - 23 o'clock when today's contributions does not exist
- notify only mention with custom message at 23:30 o'clock when today's contributions does not exist

```
hubot ghstats schedule add "0 20 * * *" moqada notify:[@]moqada
hubot ghstats schedule add "0 21-23 * * *" moqada notify:[@]moqada only failed-only:send
hubot ghstats schedule add "30 23 * * *" moqada notify:[@]moqada only failed-only:send bad:"Please commit!"
```


Another way: use with [hubot-schedule](https://github.com/matsukaz/hubot-schedule).

For example, following config is notify every 20 o'clock.

```
hubot schedule add "0 20 * * *" hubot ghstats moqada notify [@]moqada
```

send mention no contributions only.

```
hubot schedule add "0 20 * * *" hubot ghstats moqada notify [@]moqada failed-only
```

### HipChat

Graph image does not expanded in HipChat when send with GitHub link.
This solution is setting `HUBOT_GITHUB_CONTRIBUTION_STATS_DISABLE_GITHUB_LINK` or `HUBOT_GITHUB_CONTRIBUTION_STATS_RESEND_GRAPH`.


[npm-url]: https://www.npmjs.com/package/hubot-github-contribution-stats
[npm-image]: https://img.shields.io/npm/v/hubot-github-contribution-stats.svg?style=flat-square
[npm-download-url]: https://www.npmjs.com/package/hubot-github-contribution-stats
[npm-download-image]: https://img.shields.io/npm/dt/hubot-github-contribution-stats.svg?style=flat-square
[travis-url]: https://travis-ci.org/moqada/hubot-github-contribution-stats
[travis-image]: https://img.shields.io/travis/moqada/hubot-github-contribution-stats.svg?style=flat-square
[daviddm-url]: https://david-dm.org/moqada/hubot-github-contribution-stats
[daviddm-image]: https://img.shields.io/david/moqada/hubot-github-contribution-stats.svg?style=flat-square
[daviddm-dev-url]: https://david-dm.org/moqada/hubot-github-contribution-stats#info=devDependencies
[daviddm-dev-image]: https://img.shields.io/david/dev/moqada/hubot-github-contribution-stats.svg?style=flat-square
[license-url]: http://opensource.org/licenses/MIT
[license-image]: https://img.shields.io/npm/l/hubot-github-contribution-stats.svg?style=flat-square
