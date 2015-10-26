# The mathjs library is provided by a meteor package.
# Here, we just add a global configuration to do all
# computation via fractions instead of floating point.

# Sadly (at least at first glance) it looks like the
# mathjs library only supports a global config so
# this'll be annoying if/when we want to deal with
# both fractions and decimals.

math.config number: 'fraction'
