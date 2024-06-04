# frozen_string_literal: true

class User::Token::Entity
  include Solid::Model

  VALUE_SEPARATOR = "_"

  attribute :short
  attribute :long

  validate do |entity|
    short, long, errors = entity.values_at(:short, :long, :errors)

    short.errors[:value].each { errors.add(:short, _1) } if short.invalid?

    long.errors[:value].each { errors.add(:long, _1) } if long.invalid?
  end

  after_initialize do
    self.short = User::Token::ShortValue.new(short)
    self.long = User::Token::LongValue.new(long)
  end

  def self.generate
    new(short: User::Token::ShortValue.new, long: User::Token::LongValue.new)
  end

  def self.parse(value)
    short, long = value.split(VALUE_SEPARATOR)

    new(short:, long:)
  end

  def value
    "#{short.value}#{VALUE_SEPARATOR}#{long.value}"
  end

  def checksum
    @checksum ||= Digest::SHA256.hexdigest(secret)
  end

  private

  def secret
    salt1, salt2, salt3, salt4 = salt_parts

    "#{salt2}-#{salt3}.:#{long.value}:.#{salt4}_#{salt1}"
  end

  def salt_parts
    a, b, c, d, e, f, g, h = short.value.chars

    ["#{h}#{c}", "#{e}#{g}", "#{b}#{d}", "#{f}#{a}"]
  end
end
