# hubot-github-contribution-stats

[![NPM version][npm-image]][npm-url]
[![NPM downloads][npm-download-image]][npm-download-url]
[![Build Status][travis-image]][travis-url]
[![Dependency Status][daviddm-image]][daviddm-url]
[![DevDependency Status][daviddm-dev-image]][daviddm-dev-url]
[![License][license-image]][license-url]

Notify GitHub Contributions and Streaks.

## Installation

```
npm install hubot-github-contribution-stats --save
```

Then add **hubot-github-contribution-stats** to your `external-scripts.json`:

```json
["hubot-github-contribution-stats"]
```

## Sample Interaction

Show Contributions and Streaks with graph

```
Hubot> hubot ghstats moqada
Hubot> Contributions: 1278 (2015-01-23 - 2016-01-23)
Longest Streak: 140 days (2015-09-06 - 2016-01-23)
Current Streak: 140 days (2015-09-06 - 2016-01-23)
https://i.gyazo.com/34d59c9c4d184962420f9a20ba5e5f2a.png
```

Show Contributions and Streaks without graph

```
Hubot> hubot ghstats moqada text
Hubot> Contributions: 1278 (2015-01-23 - 2016-01-23)
Longest Streak: 140 days (2015-09-06 - 2016-01-23)
Current Streak: 140 days (2015-09-06 - 2016-01-23)
```

Notify exists Contributions on today

```
Hubot> hubot ghstats moqada notify
Hubot> No Contributions today...

Contributions: 1278 (2015-01-23 - 2016-01-23)
Longest Streak: 140 days (2015-09-06 - 2016-01-23)
Current Streak: 140 days (2015-09-06 - 2016-01-23)
https://i.gyazo.com/34d59c9c4d184962420f9a20ba5e5f2a.png
```

Notify exists Contributions on today with mention

```
Hubot> hubot ghstats moqada notify @moqada
Hubot> @moqada No Contributions today...

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

Contributions: 1278 (2015-01-23 - 2016-01-23)
Longest Streak: 140 days (2015-09-06 - 2016-01-23)
Current Streak: 140 days (2015-09-06 - 2016-01-23)
```

## Commands

```
hubot ghstats <username> [text] - Show user's GitHub contributions and streaks
hubot ghstats <username> notify [text|only] - Notify user's GitHub contributions
hubot ghstats <username> notify [<@user>|<[@]user>] [text|only] - Notify user's GitHub contributions with mention
```

## Configurations

```
HUBOT_GITHUB_CONTRIBUTION_STATS_ERROR_MESSAGE - Set message for error
HUBOT_GITHUB_CONTRIBUTION_STATS_ERROR_MESSAGE_404 - Set message when doesnot exist GitHub user
HUBOT_GITHUB_CONTRIBUTION_STATS_NOTIFY_MESSAGE_GOOD - Set message for notify when has contributions on today
HUBOT_GITHUB_CONTRIBUTION_STATS_NOTIFY_MESSAGE_BAD - Set message for notify when doesnot have contributions on today
HUBOT_GITHUB_CONTRIBUTION_STATS_GYAZO_TOKEN - Set Gyazo API Token for upload graph image
```

## Demo

![](https://i.gyazo.com/ba6e3edef3e4d304eca32bd11aa105e1.png)

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
