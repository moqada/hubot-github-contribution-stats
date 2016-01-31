# hubot-github-contribution-stats

[![NPM version][npm-image]][npm-url]
[![NPM downloads][npm-download-image]][npm-download-url]
[![Build Status][travis-image]][travis-url]
[![Dependency Status][daviddm-image]][daviddm-url]
[![DevDependency Status][daviddm-dev-image]][daviddm-dev-url]
[![License][license-image]][license-url]

Notify GitHub Contributions and Streaks.

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

Notify exists Contributions on today

```
Hubot> hubot ghstats moqada notify
Hubot> No Contributions today...

https://github.com/moqada
Contributions: 1278 (2015-01-23 - 2016-01-23)
Longest Streak: 140 days (2015-09-06 - 2016-01-23)
Current Streak: 140 days (2015-09-06 - 2016-01-23)
https://i.gyazo.com/34d59c9c4d184962420f9a20ba5e5f2a.png
```

Notify exists Contributions on today with mention

```
Hubot> hubot ghstats moqada notify @moqada
Hubot> @moqada No Contributions today...

https://github.com/moqada
Contributions: 1278 (2015-01-23 - 2016-01-23)
Longest Streak: 140 days (2015-09-06 - 2016-01-23)
Current Streak: 140 days (2015-09-06 - 2016-01-23)
https://i.gyazo.com/34d59c9c4d184962420f9a20ba5e5f2a.png
```

Notify exists Contributions on today with mention only message
```
Hubot> hubot ghstats moqada notify @moqada only
Hubot> @moqada No Contributions today...
```

Notify exists Contributions on today with mention without graph
```
Hubot> hubot ghstats moqada notify @moqada text
Hubot> @moqada No Contributions today...

https://github.com/moqada
Contributions: 1278 (2015-01-23 - 2016-01-23)
Longest Streak: 140 days (2015-09-06 - 2016-01-23)
Current Streak: 140 days (2015-09-06 - 2016-01-23)
```

## Commands

```
hubot ghstats [<name>|"<name1> <name2>..."] [text] - Show user's GitHub contributions and streaks
hubot ghstats [<name>|"<name1> <name2>..."] notify [text|only] - Notify user's GitHub contributions
hubot ghstats [<name>|"<name1> <name2>..."] notify [<@user>|<[@]user>] [text|only] [failed-only] - Notify user's GitHub contributions with mention
```

## Configurations

```
HUBOT_GITHUB_CONTRIBUTION_STATS_DISABLE_GITHUB_LINK - Set disable GitHub link in message
HUBOT_GITHUB_CONTRIBUTION_STATS_ERROR_MESSAGE - Set message for error
HUBOT_GITHUB_CONTRIBUTION_STATS_ERROR_MESSAGE_404 - Set message when does not exist GitHub user
HUBOT_GITHUB_CONTRIBUTION_STATS_NOTIFY_MESSAGE_GOOD - Set message for notify when has contributions on today
HUBOT_GITHUB_CONTRIBUTION_STATS_NOTIFY_MESSAGE_BAD - Set message for notify when does not have contributions on today
HUBOT_GITHUB_CONTRIBUTION_STATS_GYAZO_TOKEN - Set Gyazo API Token for upload graph image
HUBOT_GITHUB_CONTRIBUTION_STATS_RESEND_GRAPH - Set resending graph image (for HipChat)
```

## Tips

### Scheduled tasks

If you want to notify every day. please use with [hubot-schedule](https://github.com/matsukaz/hubot-schedule).
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
