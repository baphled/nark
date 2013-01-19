SimpleCov.start do
  add_filter "/spec/"
  add_filter "/features/"

  add_group 'Core', 'lib'
  add_group 'Plugin Component', 'lib/nark/plugin'
end
