String.class_eval do
  def indent(num_spaces)
    sub(/^/, ' ' * num_spaces)
  end
end
