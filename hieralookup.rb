#!/usr/bin/ruby

require 'uri'
require 'hiera'
require 'json'
require 'sinatra'

hiera = Hiera.new
Hiera.logger='noop'

get '/' do
  'Hiera lookup service'
end

get '/test/:_key' do 
  { 'value' => params[:_key] }.to_json
end

get '/hiera/?:_resolution_type?/:_key' do
  scope = Hash.new
  unless params[:kernel].nil? or params[:kernel].empty? 
    scope['::kernel'] = params[:kernel]
  end
  
  res = hiera.lookup(params[:_key], nil, scope, nil, params[:_resolution_type] ? params[:_resolution_type].to_sym : :priority)
  next [404, 'Key not found'] if res == nil
  { 'value' => res }.to_json
end

