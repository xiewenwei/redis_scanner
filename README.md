# RedisScanner [![Build Status][travis-image]][travis-link]

[travis-image]: https://travis-ci.org/xiewenwei/redis_scanner.svg?branch=master
[travis-link]: http://travis-ci.org/xiewenwei/redis_scanner
[travis-home]: http://travis-ci.org/

RedisScanner is a tiny tool for scanning all redis keys and creating statistic result. The features are the followings.

* Scans keys using *scan* replacing *keys* command.
* Creates statistic result by key's pattern.
* Provide key's detail information which includes type and size.
* Provide table format output..

## Installation

Install redis_scanner in shell.

```shell
gem install redis_scanner
```

*Installation prerequirement*

You should install [ruby](https://www.ruby-lang.org/) first.

## Usage

* Get started

You can run it directly after install. It will scan local redis instance when you just input *redis_scanner*.

```shell
redis_scanner
```

The Output is like this:

```shell
+------------------------------------+-------+
| Key                                | Count |
+------------------------------------+-------+
| demo:user:<id>:counter             | 10000 |
| u:<uuid>:pf                        |    52 |
| sidekiq_demo:stat:failed:<date>    |     4 |
| sidekiq_demo:stat:processed:<date> |     4 |
| _sp_one:queue:default              |     1 |
| bh:queues                          |     1 |
...
+------------------------------------+-------+
```

```shell
redis_scanner -d -l 10
```

The Output is like this:

```shell
+------------------------------------+--------+-------+--------+---------+
| Key                                | Type   | Count | Size   | AvgSize |
+------------------------------------+--------+-------+--------+---------+
| demo:user:<id>:counter             | string | 10000 | 927510 |   92.75 |
| u:<uuid>:pf                        | hash   |    52 |    108 |    2.08 |
| sidekiq_demo:stat:failed:<date>    | string |     4 |      5 |    1.25 |
| sidekiq_demo:stat:processed:<date> | string |     4 |      6 |     1.5 |
| _sp_one:queue:default              | list   |     1 |      1 |     1.0 |
| bh:queues                          | set    |     1 |      1 |     1.0 |
| bh:retry                           | zset   |     1 |      1 |     1.0 |
| bh:stat:failed                     | string |     1 |      1 |     1.0 |
| bh:stat:processed                  | string |     1 |      1 |     1.0 |
| bus_app:app_two                    | hash   |     1 |      1 |     1.0 |
+------------------------------------+--------+-------+--------+---------+
```

* Scan keys with some pattern

```shell
redis_scanner -m u:*
```

* Output statistic result to a file

```shell
redis_scanner -f keys_stat.txt
```

* Redis options. The options are same of redis-cli.

```shell
redis_scanner -h <host> -p <port> ...
```

## Development

You are free to modify it for your need.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xiewenwei/redis_scanner. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

