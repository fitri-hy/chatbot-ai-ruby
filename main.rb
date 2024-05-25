require 'sinatra'
require 'net/http'
require 'json'
require 'redcarpet'

get '/' do
  erb :index
end

post '/chat' do
  question = params[:question]
  response = fetch_response(question)
  content_type :json
  { text: response_to_html(response), markdown: true }.to_json
end

def fetch_response(question)
  encoded_question = URI.encode_www_form_component(question)
  uri = URI("https://hytech-api.vercel.app/api/gemini/#{encoded_question}")
  response = Net::HTTP.get(uri)
  JSON.parse(response)['text']
rescue StandardError => e
  puts "Error: #{e.message}"
  "Maaf, terjadi kesalahan saat menghubungi chatbot."
end  

def response_to_html(response)
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, fenced_code_blocks: true)
  markdown.render(response)
end
