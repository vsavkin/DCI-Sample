module ContextAccessor
  def context
    Thread.current[:context]
  end
end