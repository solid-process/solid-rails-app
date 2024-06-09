# frozen_string_literal: true

module Solid::Context
  Action = Struct.new(:name, :process) do
    def dependencies
      attributes_of(process.dependencies)
    end

    def input
      attributes_of(process.input)
    end

    private

    def attributes_of(arg)
      arg&.attribute_types&.each_with_object({}) { |(name, type), memo| memo[name.to_sym] = type.type } || {}
    end
  end

  def self.extended(mod)
    mod.extend(mod)
  end

  def actions=(options)
    options
      .each_with_object({}) { |(name, process), memo| memo[name] = Action.new(name, process).freeze }.freeze
      .then { _actions.merge!(_1) }
  end

  def actions
    _actions.keys
  end

  def action?(name)
    _actions.key?(name)
  end

  def action(name)
    _actions[name]
  end

  def import(contexts)
    contexts.each do |name, context|
      context.is_a?(Solid::Context) or raise ArgumentError, "Expected a Solid::Context, got a #{context}"

      _actions[name] = context
    end
  end

  def respond_to_missing?(name, include_private = false)
    action?(name) || super
  end

  UNDEFINED = Object.new

  def method_missing(name, arg = UNDEFINED)
    return super unless action?(name)

    action = action(name)

    return action if action.is_a?(::Solid::Context)

    (arg == UNDEFINED) ? action.process : action.process.call(arg)
  end

  private

  def _actions
    @actions ||= {}
  end
end
