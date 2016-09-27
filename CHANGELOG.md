<a name="0.6.0"></a>
# [0.6.0](https://github.com/moqada/hubot-github-contribution-stats/compare/v0.5.5...v0.6.0) (2016-09-27)

### BREAKING CHANGES

- Requires Node.js version 5 (#14)[https://github.com/moqada/hubot-github-contribution-stats/pull/14]



<a name="0.5.5"></a>
## [0.5.5](https://github.com/moqada/hubot-github-contribution-stats/compare/v0.5.4...v0.5.5) (2016-06-07)


### Dependencies

* Update github-contribution-stats to 0.3.0 supporting new GitHub contributions. ([#6](https://github.com/moqada/hubot-github-contribution-stats/pull/6))



<a name="0.5.4"></a>
## [0.5.4](https://github.com/moqada/hubot-github-contribution-stats/compare/v0.5.3...v0.5.4) (2016-02-18)


### Dependencies

* Scheduler replace to @moqada/hubot-schedule-helper ([#2](https://github.com/moqada/hubot-github-contribution-stats/pull/2))



<a name="0.5.3"></a>
## [0.5.3](https://github.com/moqada/hubot-github-contribution-stats/compare/v0.5.2...v0.5.3) (2016-02-10)


### Bug Fixes

* **hubot-github-contribution-stats:** Fix RegExp for username ([2666629](https://github.com/moqada/hubot-github-contribution-stats/commit/2666629))



<a name="0.5.2"></a>
## [0.5.2](https://github.com/moqada/hubot-github-contribution-stats/compare/v0.5.1...v0.5.2) (2016-02-10)


### Bug Fixes

* **hubot-github-contribution-stats:** Fix broken resendGraph ([86168e8](https://github.com/moqada/hubot-github-contribution-stats/commit/86168e8))



<a name="0.5.1"></a>
## [0.5.1](https://github.com/moqada/hubot-github-contribution-stats/compare/v0.5.0...v0.5.1) (2016-02-09)


### Bug Fixes

* **hubot-github-contribution-stats:** :bug: Fix typo ([b119d3b](https://github.com/moqada/hubot-github-contribution-stats/commit/b119d3b))
* **hubot-github-contribution-stats:** Fix RegExp for schedule pattern ([320c968](https://github.com/moqada/hubot-github-contribution-stats/commit/320c968))



<a name="0.5.0"></a>
# [0.5.0](https://github.com/moqada/hubot-github-contribution-stats/compare/v0.4.2...v0.5.0) (2016-02-06)


### Bug Fixes

* **hubot-github-contribution-stats:** Change notify format ([741c591](https://github.com/moqada/hubot-github-contribution-stats/commit/741c591))
* **hubot-github-contribution-stats:** Fix error on no GYAZO_TOKEN ([fb1a987](https://github.com/moqada/hubot-github-contribution-stats/commit/fb1a987))

### Features

* **hubot-github-contribution-stats:** Add configs of messages ([099371a](https://github.com/moqada/hubot-github-contribution-stats/commit/099371a))
* **hubot-github-contribution-stats:** Add options: failed-only, good, bad ([9406a0e](https://github.com/moqada/hubot-github-contribution-stats/commit/9406a0e))
* **hubot-github-contribution-stats:** Add schedule command ([5797525](https://github.com/moqada/hubot-github-contribution-stats/commit/5797525))


### BREAKING CHANGES

* Change failed-only format

Before:

`hubot ghstats moqada notify failed-only`

After:

```
hubot ghstats moqada notify failed-only:mention
hubot ghstats moqada notify failed-only:send
```
* Change notify format.

Before:

`hubot ghstats moqada notify [@]moqada`

After:

`hubot ghstats moqada notify:[@]moqada`



<a name="0.4.2"></a>
## [0.4.2](https://github.com/moqada/hubot-github-contribution-stats/compare/v0.4.1...v0.4.2) (2016-01-27)


### Bug Fixes

* **hubot-github-contributions-stats:** Fix order of sending and resending image ([906a2fe](https://github.com/moqada/hubot-github-contribution-stats/commit/906a2fe))



<a name="0.4.1"></a>
## [0.4.1](https://github.com/moqada/hubot-github-contribution-stats/compare/v0.4.0...v0.4.1) (2016-01-27)


### Bug Fixes

* **hubot-github-contribution-stats:** Fix notify error ([b58399a](https://github.com/moqada/hubot-github-contribution-stats/commit/b58399a))
* **hubot-github-contribution-stats:** Remove console ([707180b](https://github.com/moqada/hubot-github-contribution-stats/commit/707180b))



<a name="0.4.0"></a>
# [0.4.0](https://github.com/moqada/hubot-github-contribution-stats/compare/v0.3.1...v0.4.0) (2016-01-27)


### Features

* **hubot-github-contribution-stats:** Add RESEND_GRAPH config (for HipChat) ([f1154d3](https://github.com/moqada/hubot-github-contribution-stats/commit/f1154d3))
* **hubot-github-contribution-stats:** Support multiple usernames ([306a14c](https://github.com/moqada/hubot-github-contribution-stats/commit/306a14c))



<a name="0.3.1"></a>
## [0.3.1](https://github.com/moqada/hubot-github-contribution-stats/compare/v0.3.0...v0.3.1) (2016-01-25)


### Bug Fixes

* **hubot-github-contribution-stats:** Fix graph image (remove text) ([b6f2019](https://github.com/moqada/hubot-github-contribution-stats/commit/b6f2019))



<a name="0.3.0"></a>
# [0.3.0](https://github.com/moqada/hubot-github-contribution-stats/compare/v0.2.0...v0.3.0) (2016-01-25)


### Bug Fixes

* **hubot-github-contribution-stats:** Fix image size ([622cb22](https://github.com/moqada/hubot-github-contribution-stats/commit/622cb22))

### Features

* **hubot-github-contribution-stats:** Add DISABLE_GITHUB_LINK to Configuration ([3ab33ef](https://github.com/moqada/hubot-github-contribution-stats/commit/3ab33ef))
* **hubot-github-contribution-stats:** Add failed-only option ([0952ee2](https://github.com/moqada/hubot-github-contribution-stats/commit/0952ee2))
* **hubot-github-contribution-stats:** Add GitHub URL to message ([817c8f2](https://github.com/moqada/hubot-github-contribution-stats/commit/817c8f2))



<a name="0.2.0"></a>
# [0.2.0](https://github.com/moqada/hubot-github-contribution-stats/compare/v0.1.0...v0.2.0) (2016-01-25)


### Features

* **hubot-github-contribution-stats:** Add notify command format ([368b26d](https://github.com/moqada/hubot-github-contribution-stats/commit/368b26d))



<a name="0.1.0"></a>
# 0.1.0 (2016-01-23)


First Release!
