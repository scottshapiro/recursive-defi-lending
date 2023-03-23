#!/usr/bin/env ruby

# This script calculates the net interest on recursively lending an asset in a DeFi system
# based on user-supplied parameters.

# Check if there are enough command-line arguments
if ARGV.size < 6
  # Display usage message and example if not enough arguments are provided
  puts "Usage: recint <collateral_factor> <loan_health> <supply_apr> <supply_bonus> <borrow_apr> <borrow_bonus>"
  # ...
  exit 1
end

# Gather input and convert the command-line arguments to floating-point numbers
cf, health, supply_apr, supply_bonus, borrow_apr, borrow_bonus = ARGV.map(&:to_f)

# Convert collateral factor to a decimal value
cf /= 100

# Calculate recursive supply and borrow
total_supply = 1 / (1 - cf/health)
total_borrow = total_supply * cf/health

# Calculate base APR and bonus APR
base_supply_apr, bonus_supply_apr = total_supply * supply_apr, total_supply * supply_bonus
base_borrow_apr, bonus_borrow_apr = total_borrow * borrow_apr, total_borrow * borrow_bonus
base_apr, bonus_apr = base_supply_apr - base_borrow_apr, bonus_supply_apr + bonus_borrow_apr

# Calculate total APR
total_apr = base_apr + bonus_apr

# Define a helper method to convert a floating-point number to a percentage string
def percent(f)
  '%.2f' % f + '%'
end

# Output the results in a human-readable format
puts "Base APR:  #{percent(base_apr)}"
puts "Bonus APR: #{percent(bonus_apr)}"
puts "Total APR: #{percent(total_apr)}"
