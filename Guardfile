# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'spork', rspec_env: { 'RAILS_ENV' => 'test' } do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch('spec/spec_helper.rb')
end

# guard 'rspec', cli: "--color --fail-fast" do
guard 'rspec', cli: "--color" do
  watch(%r{^spec/.+_spec\.rb})
  watch(%r{^lib/(.+)\.rb})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb') { "spec" }

  # Rails example
  watch('spec/spec_helper.rb')                       { "spec" }
  watch('config/routes.rb')                          { "spec/routing" }
  watch(%r{^app/(.+)/application_controller.rb}) { |m| "spec/#{m[1]}" }
  watch(%r{^app/mailers/application_mailer.rb}) { |m| "spec/mailers" }
  watch(%r{^spec/.+_spec\.rb})
  watch(%r{^spec/support/.+_helper\.rb})
  watch(%r{^app/(.+)\.rb})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.+)\.html.haml})                           { |m| "spec/#{m[1]}.html.haml_spec.rb" }
  watch(%r{^app/(.+)\.json.json_builder})                           { |m| "spec/#{m[1]}.json.json_builder_spec.rb" }
  watch(%r{^lib/(.+)\.rb})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^app/lib/(.+)\.rb})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/requests/#{m[1]}_spec.rb"] }
end
