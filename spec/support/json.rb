require 'json'

def load_json_file(file_path)
  JSON.parse(File.read("spec/fixtures/#{file_path}"))
end
