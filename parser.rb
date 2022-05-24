#!/usr/bin/ruby

require 'csv'

DECARBOXYLATION_FACTOR = 0.877
TERPENE = ['ol', 'ene']

def potential(*row)
#   puts "potential: #{row}"
  oid = 0
  fraction = 0

    row.each do |item|
        if item[0].downcase.end_with?('a')
            fraction = item[1]
        else
            oid = item[1]
        end
    end
  #puts "oid: #{oid}, fraction: #{fraction}"
  possible = (oid.to_f + (DECARBOXYLATION_FACTOR * fraction.to_f))
  return format('%.2f', (possible * 100))
end

def terpene_total(*row)
  #puts "terpene_total: #{row}"
  terpene_total = 0.to_f
  row.each do |item|
    terpene_total += item[1].to_f
  end
  return format('%.2f', terpene_total * 100) 
end

unless ARGV.length == 1
    puts "Usage: ruby parser.rb <filename>"
    exit
end

input_file = ARGV[0]

csv = CSV.read(input_file)

# csv.each do |row|
#     puts "#{row}"
# end

c = csv.find_all { |row| row[0].downcase.start_with?("cbd")}
t = csv.find_all { |row| row[0].downcase.start_with?("thc")}

terps = csv.find_all { |row| row[0].downcase.end_with?(*TERPENE)}

# puts "CBD: #{c}"
# puts "THC: #{t}"
# puts "Terpenes: #{terps}"

# CBD
cbd_potential = potential(*c)

# THC
thc_potential = potential(*t)

# Terpene
terpene_content = terpene_total(*terps) unless terps.empty?

puts "THC potential: #{thc_potential}%"
puts "CBD potential: #{cbd_potential}%"
puts "Terpene content: #{terpene_content}%"