## Schematron-wrapper [![Build Status](https://travis-ci.org/Agilefreaks/schematron-wrapper.png?branch=master)](https://travis-ci.org/Agilefreaks/schematron-wrapper)

A wrapper around various schematron implementations.

Currently we support: saxon.

## Prerequierments

Java should be install in the bin PATH on the target machine.

## Usage

```ruby
# schematron_file - the schematron file content used for validation
# the compilation is time consuming you might consider caching the result
compiled_schematron = Schematron::XSLT2.compile(schematron_file)

# target_xml - a file you will use to validate against
validation_result = Schematron::XSLT2.validate(compiled_schematron, target_xml)

# and finally get the errors
errors = Schematron::XSLT2.get_errors(validation_result)
```

Check our `spec/lib/schematron_spec.rb` for a complete example.

## Compatibility

Schematron-wrapper is tested against Ruby 2.1.0

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
