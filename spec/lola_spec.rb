require 'spec_helper'

RSpec.describe Lola do
  it 'has a version number' do
    expect(Lola::VERSION).not_to be nil
  end

  it 'does something useful' do
    puts (:s + :d).inspect
  end

  it 'can evaluate' do
    puts (:s + :d).evaluate(s: 1, d: 2)
  end

  it 'raises evaluate errors on type problems' do
    expect {
      (:s + :d).evaluate(s: 1, d: 'd')
    }.to raise_error Lola::EvaluationError
  end

  it 'raises evaluate errors on operator problems' do
    expect {
      (:s.⇒ :d).evaluate(s: 1, d: 1)
    }.to raise_error Lola::EvaluationError
  end

  it 'does something more conplex' do
    puts :s + :d.⇒(:hehe)
  end

  it 'monkey patches Symbol' do
    ensure_that :s.respond_to? :query_inspect
    ensure_that Symbol.include? Lola::Joinable
  end
end
