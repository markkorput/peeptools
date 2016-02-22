Gem::Specification.new do |s|
  s.name = "peeptools"
  s.version = '0.0.1'
  s.date = '2016-02-22'

  s.author = "Mark van de Korput"
  s.email = "dr.theman@gmail.com"
  
  s.summary = %q{Some ruby classes for streamlined but _very_ opiniated data-handling when working with a multi-gopro VR camera}
  s.description = s.summary
  s.homepage = %q{https://github.com/markkorput/peeptools}
  s.license = 'MIT'

  s.files = `git ls-files`.split($/)
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.add_development_dependency 'rake', '~> 10.1'
  s.add_development_dependency 'rspec', '~> 3.3'
end
