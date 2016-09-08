# Defines the matching rules for Guard.
guard :minitest, spring: "bin/rails test" do
  watch(%r{^test/(.*)/(.*)_test\.rb$})
  watch(%r{^app/models/(.*)\.rb}) do |m|
    "test/models/#{m[1]}_test.rb"
  end
  watch(%r{^app/controllers/(.*)\.rb}) do |m|
    "test/controllers/#{m[1]}_test.rb"
  end
end
