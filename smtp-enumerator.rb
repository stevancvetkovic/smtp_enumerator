#!/usr/bin/ruby

#####################################################
# ------------- SMTP-ENUMERATOR 0.3 -----------------
# -----------enumeracija naloga e-poste--------------
#####################################################
# Autor: Stevan Cvetkovic
# E-posta: cvetkovic.stevan@gmail.com
# GPG/PGP kljuc: 0x4637D767
# Datum: 10. septembar 2010.
#####################################################
# PROGRAM JE NAPISAN ISKLJUCIVO U EDUKATIVNE SVRHE. 
# AUTOR SE U POTPUNOSTI OGRADJUJE OD MOGUCIH 
# ZLOUPOTREBA OVOG PROGRAMA!
#####################################################

require 'socket'

unless ARGV.length == 2
  puts "Poziv: ruby smtp-enumerator.rb <adresa> <fajl-korisnici> \n"
  exit
end

$adresa = ARGV[0]
$korisnici = IO.readlines(ARGV[1])

$izlaz = File.open("izlaz.txt", "a")
$izlaz.write("Adresa: " + $adresa + "\n\n")

$uspeh = 0

def povezivanje
	$s = TCPSocket.open($adresa, 25)
	puts $s.gets
	$s.puts('helo you' + "\r\n")
	puts $s.gets
	$s.puts('mail from: neko@nesto.gov' + "\r\n")
	puts $s.gets
end

def petlja
	$korisnici.each do |k|
		$s.puts('rcpt to: ' + k.chomp + "\r\n")
		o = $s.gets
		if o.index("250")
			puts 'USPEH! Korisnik: ' + k
			$izlaz.write(k)
			$uspeh = 1
		elsif o.index("421")
			$s.close
			povezivanje
			next
		else
			puts k
		end
	end
end

povezivanje
petlja

if $uspeh == 1
	puts "\nUSPEH! Proveri datoteku izlaz.txt!"
else
	puts "\nNisu pronadjeni validni korisnici za zadati niz imena."
	izlaz.write("\nNisu pronadjeni validni korisnici za zadati niz imena.")
end

$izlaz.close
$s.close
