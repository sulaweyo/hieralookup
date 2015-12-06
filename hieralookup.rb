#!/usr/bin/ruby

require 'uri'
require 'hiera'
require 'json'
require 'sinatra'

hiera = Hiera.new
Hiera.logger='noop'

get '/' do
  'Hello to Hiera Lookup service'
end

get '/hiera/?:_resolution_type?/:_key' do
  scope = Hash.new
  if params[:kernel].empty? 
    next [404, 'Kernel param missing']
  end
  scope['::kernel'] = params[:kernel]
  res = hiera.lookup(params[:_key], nil, scope, nil, params[:_resolution_type] ? params[:_resolution_type].to_sym : :priority)
  next [404, 'Key not found'] if res == nil
  out = { 'value' => res }.to_json
  $? == 0 ? out : [500, out]
end

