require 'sinatra'
require 'haml'
require 'json'


helpers do

  def get_entries(path)
    Dir["#{path}/*"]
  end

  def query_path(path)
    path.gsub(settings.file_root + '/', '')
  end

  def back_path(path)
    size = path.split("/").size
    result = (size >= 1 ? path.split("/").take(size - 1).join("/") : "")
  end

  def generate_content(url)
    directories = []
    files = []
    result = []
    result_hash = {}

    full_path = "#{settings.file_root}/#{url}"
    result_hash.store(:current, full_path)
    
    path = query_path(full_path)
    parent = back_path(path)
    result_hash.store(:parent, parent)

    get_entries(full_path).each do |ent|
      if(File.directory?(ent))
        directories << { path: query_path(ent), name: File.basename(ent) }
      else
        files << { name: File.basename(ent) }
      end
    end

    result_hash.store(:dir, directories)
    result_hash.store(:file, files)
    result << result_hash

    content_type :json
    result.to_json
  end

end

get '/entries/*' do |entry|
  generate_content entry  
end

get '/' do
  haml :index
end




