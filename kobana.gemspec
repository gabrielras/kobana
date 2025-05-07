# frozen_string_literal: true

require_relative "lib/kobana/version"

Gem::Specification.new do |spec|
  spec.name          = "kobana"
  spec.version       = Kobana::VERSION
  spec.authors       = ["gabrielras"]
  spec.email         = ["gabrielras12@hotmail.com"]

  spec.summary       = "Cliente Ruby para a API da Kobana."
  spec.description   = "Biblioteca Ruby para facilitar a integração com a API da Kobana."
  spec.homepage      = "https://github.com/gabrielras/kobana"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"]     = spec.homepage
  spec.metadata["source_code_uri"]  = spec.homepage

  spec.files = Dir["lib/**/*", "README.md", "LICENSE"]

  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 2.0"
  spec.add_dependency "faraday-retry", "~> 2.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "vcr", "~> 6.0"
  spec.add_development_dependency "webmock", "~> 3.14"
end
