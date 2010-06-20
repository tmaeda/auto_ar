# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{auto_ar}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tomoki MAEDA"]
  s.cert_chain = ["/home/tmaeda/.gemcert/gem-public_cert.pem"]
  s.date = %q{2010-06-20}
  s.description = %q{A gem that makes ActiveRecord subclasses on the fly}
  s.email = %q{tmaeda _at_ ruby-sapporo.org}
  s.extra_rdoc_files = ["lib/auto_ar.rb"]
  s.files = ["Manifest", "Rakefile", "lib/auto_ar.rb", "test/auto_ar_test.rb", "test/test_helper.rb", "auto_ar.gemspec"]
  s.homepage = %q{http://github.com/tmaeda/auto_ar}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Auto_ar"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{auto_ar}
  s.rubygems_version = %q{1.3.5}
  s.signing_key = %q{/home/tmaeda/.gemcert/gem-private_key.pem}
  s.summary = %q{A gem that makes ActiveRecord subclasses on the fly}
  s.test_files = ["test/auto_ar_test.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
