#!/usr/bin/ruby

require 'uri'
require 'hiera'
require 'puppet'
require 'json'
require 'sinatra'
require 'time'
require 'logger'

get '/' do
  'Hello to Hiera Lookup service'
end

log = Logger.new('hieralookup.log')
log.level = Logger::INFO

hiera = Hiera.new
Hiera.logger='noop'

get '/hiera/:_key' do
  log.info("Request for fact #{params[:_key]} received")
  scope = Hash.new
  if params[:kernel].empty? 
    next [404, 'Kernel param missing']
  end
  scope['::kernel'] = params[:kernel]
  res = hiera.lookup(params[:_key], nil, scope, nil, :priority)
  next [404, 'Key not found'] if res == nil
  out = { 'value' => res }.to_json
  $? == 0 ? out : [500, out]
end
