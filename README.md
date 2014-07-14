# Unicorn::AutoScaling

Minimalistic auto-scaling for Unicorn.

## Installation

Add this line to your application's Gemfile:

    gem 'unicorn-autoscaling', require: false

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install unicorn-autoscaling

## Usage

Add the following `require` to your unicorn configuration file:

    require 'unicorn/autoscaling'

And enable autoscaling by adding:

    autoscaling true


## Configuration options

    autoscaling true

    autoscale_idle_time_decrement 30

    autoscale_idle_time_increment 10

    autoscale_idle_time_samples 20

    autoscale_check_interval 10

    autoscale_min_workers 4

    autoscale_max_workers 16

## Contributing

1. Fork it ( https://github.com/ydkn/unicorn-autoscaling/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
