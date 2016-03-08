#!/usr/bin/ruby
#encoding:utf-8
require 'mail'

$EMAIL_SERVER = 'smtp.qq.com'
$USER_NAME = 'wzshiming@foxmail.com'
$PASSWORD = 'shiming10120'

Mail.defaults do
	delivery_method :smtp, 
							address:					$EMAIL_SERVER,
							port:							25,
							domain:						$EMAIL_SERVER,
							user_name:				$USER_NAME,
							password:					$PASSWORD ,
							authentication:			'plain',
							enable_starttls_auto:	true
end

if $0 == __FILE__
	mail=Mail.new do
		to $*[2..-1]
		from $USER_NAME
		subject $*[0]
		body $*[1]
		#add_file filename: 'app.rb', data: File.read('./app.rb')
	end
	mail.deliver!
end