#!/usr/bin/env ruby

# Copy this file as `recint` (or whatever you want) somewhere in your path and
# use it according to the usage notes below!

if ARGV.size < 4
  puts "Usage: recint <collateral_factor> <loan_health> <supply_apr> <supply_bonus> <borrow_apr> <borrow_bonus>"
  puts
  puts "  Example - To calculate the net interest on recursively lending this asset given system parameters and your target loan health:"
  puts
  puts "    80% collateral factor (CF)"
  puts "    1.03 loan health"
  puts "    2.5% supply APR"
  puts "    3.7% supply incentive APR"
  puts "    3.2% borrow APR"
  puts "    2.1% borrow incentive APR"
  puts
  puts "  Use this command:"
  puts
  puts "    recint 80 1.03 2.5 3.7 3.2 2.1"
  puts 
  puts "  Output:"
  puts
  puts "    Base APR:  -0.30%"
  puts "    Bonus APR: 26.90%"
  puts "    Total APR: 26.60%"
  puts
  exit 1
end

# Gather input
cf, health, supply_apr, supply_bonus, borrow_apr, borrow_bonus = ARGV.map(&:to_f)
cf /= 100

# Calculate recursive supply and borrow
total_supply = 1 / (1 - cf/health)
total_borrow = total_supply * cf/health

# Calculate base apr
base_supply_apr = total_supply * supply_apr
base_borrow_apr = total_borrow * borrow_apr
base_apr = base_supply_apr - base_borrow_apr

# Calculate bonus apr
bonus_supply_apr = total_supply * supply_bonus
bonus_borrow_apr = total_borrow * borrow_bonus
bonus_apr = bonus_supply_apr + bonus_borrow_apr

# Calculate total apr
total_apr = base_apr + bonus_apr

def percent(f)
  '%.2f' % f + '%'
end

puts "Base APR:  #{percent(base_apr)}"
puts "Bonus APR: #{percent(bonus_apr)}"
puts "Total APR: #{percent(total_apr)}"
