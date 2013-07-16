require 'rubygems'
require "em-synchrony/mysql2"

environment :production do
  ActiveRecord::Base.establish_connection(:adapter  => 'em_mysql2',
                                          :database => 'piecemaker2_test',
                                          :username => 'root',
                                          :password => 'root',
                                          :host     => 'localhost',
                                          :pool     => 1)
end

environment :development do
  ActiveRecord::Base.establish_connection(:adapter  => 'em_mysql2',
                                          :database => 'piecemaker2_test',
                                          :username => 'root',
                                          :password => 'root',
                                          :host     => 'localhost',
                                          :pool     => 1)
end

environment :test do
  puts "hallo"
  ActiveRecord::Base.establish_connection(:adapter  => 'em_mysql2',
                                          :database => 'piecemaker2',
                                          :username => 'root',
                                          :password => '',
                                          :host     => 'localhost',
                                          :pool     => 1)
end
