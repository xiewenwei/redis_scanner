# RedisScanner

RedisScanner is a tiny tool for scanning all redis keys and creating statistic result. The features are the followings.

* Scans keys using *scan* replacing *keys* command.
* Creates statistic result by key's pattern.

## Installation

Install redis_scanner in shell.

```shell
gem install redis_scanner
```

*Installation prerequirement*

You should install [ruby](https://www.ruby-lang.org/) first.

## Usage

* Use default options

```shell
redis_scanner
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

