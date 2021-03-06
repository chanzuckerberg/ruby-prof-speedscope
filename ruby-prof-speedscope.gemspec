Gem::Specification.new do |s|
  s.name          = 'ruby-prof-speedscope'
  s.version       = '0.3.0'
  s.date          = '2020-04-20'
  s.summary       = 'A ruby-prof printer compatible with speedscope.app.'
  s.authors       = ["Chan Zuckerberg Initiative"]
  s.email         = 'opensource@chanzuckerberg.com'
  s.homepage      = 'https://github.com/chanzuckerberg/ruby-prof-speedscope'
  s.license       = 'MIT'
  s.files         = ['lib/ruby-prof-speedscope.rb']
  s.add_runtime_dependency "ruby-prof", "~>1.0"
end
