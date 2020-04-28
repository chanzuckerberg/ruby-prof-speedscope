# ruby-prof-speedscope
[![Gem Version](https://badge.fury.io/rb/ruby-prof-speedscope.svg)](https://badge.fury.io/rb/ruby-prof-speedscope)

A ruby-prof printer compatible with the speedscope.app trace viewer.

## Installation
Add to your Gemfile
```ruby
gem 'ruby-prof-speedscope'
```
then install.
```sh
$ bundle install
```

## Usage
```ruby
# Collect the profile.
RubyProf.start
  ...
results = RubyProf.stop

# Save the printer output.
File.open("trace.rubyprof") do |f|
  RubyProf::SpeedscopePrinter.new(results).print(f)
end

# Go to https://speedscope.app
# Open the trace there.
```

## Dependencies
- Profiler: `ruby-prof` (https://https://ruby-prof.github.io/)
- Trace Viewer: https://speedscope.app (https://github.com/jlfwong/speedscope/)

## Contributing
Contributions and ideas are welcome! Please don't hesitate to open an issue or send a pull request to improve the functionality of this gem.

This project adheres to the Contributor Covenant [code of conduct](https://github.com/chanzuckerberg/.github/tree/master/CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to opensource@chanzuckerberg.com.

## Reporting Security Issues
If you believe you have found a security issue, please responsibly disclose by contacting us at security@chanzuckerberg.com. For additional details please see [our security guide](SECURITY.md).

## License
This project is licensed under [MIT](https://github.com/chanzuckerberg/ruby-prof-speedscope/blob/master/LICENSE).
