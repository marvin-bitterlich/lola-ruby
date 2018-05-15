require 'spec_helper'
require 'hashie'

RSpec.describe Lola do
  describe 'general lola module' do
    it 'has a version number' do
      expect(Lola::VERSION).not_to be nil
    end

    it 'monkey patches Symbol' do
      ensure_that :s.respond_to? :query_inspect
      ensure_that Symbol.include? Lola::Joinable
    end
  end


  describe 'query building' do
    describe 'smoke tests' do
      it 'does not raise any exception on basic +' do
        :s + :d
      end

      it 'does not raise any exception on basic -' do
        :s + :d
      end

      it 'does not raise any exception on chained queries' do
        :s + :d + :x + :something
      end

      it 'does not raise any exception on being inspected' do
        (:s + :d).inspect
      end

      it 'does not raisa any exception on custom operator ⇒' do
        :d.⇒(:hehe)
      end
    end

    describe 'query string tests' do
      it 'can print (s + d)' do
        expect(
          (:s + :d).inspect
        ).to eq '(s + d)'
      end

      it 'can print (s - d)' do
        expect(
          (:s - :d).inspect
        ).to eq '(s - d)'
      end

      it 'can print (s ⇒ d)' do
        expect(
          (:s.⇒ :d).inspect
        ).to eq '(s ⇒ d)'
      end

      it 'can print (((s + d) + x) + something)' do
        expect(
          (:s + :d + :x + :something).inspect
        ).to eq '(((s + d) + x) + something)'
      end

      it 'can print ((s + d) + (x + something))' do
        expect(
          ((:s + :d) + (:x + :something)).inspect
        ).to eq '((s + d) + (x + something))'
      end
    end
  end

  describe 'query evaluation' do
    describe 'smoke tests' do
      it 'does not raise any exceptions on basic +' do
        (:s + :d).evaluate(s: 1, d: 2)
      end

      it 'does not raise any exceptions on basic -' do
        (:s - :d).evaluate(s: 1, d: 2)
      end

      it 'does not raise any exceptions on method uses' do
        (:s - :d).evaluate(Hashie::Mash.new s: 1, d: 2)
      end

      it 'allows static variables' do
        (:s - 2).evaluate(s: 1)
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
    end

    describe 'result tests' do
      it 'calculates 1 + 2 = 3' do
        expect(
          (:s + :d).evaluate(s: 1, d: 2)
        ).to be 3
      end
    end
  end

  describe 'DSL' do
    describe 'smoke tests' do
      it 'does basic things' do
        Lola.spec do
          define :something do
            (:s + :d)
          end
        end
      end
      it 'does not allow double assign' do
        expect {
          Lola.spec do
            define :something do
              (:s + :d)
            end
            define :something do
              (:s + :e)
            end
          end
        }.to raise_error Lola::MappingError
      end
      it 'does a trigger' do
        Lola.spec do
          define :something do
            (:s + :d) > 5
          end
          trigger :something
        end
      end
    end

    describe 'store tests' do
      it 'does basic things' do
        spec = Lola.spec do
          define :something do
            (:s + :d)
          end
        end
        expect(spec.print(:something)).to eq '(s + d)'
      end
      it 'does a trigger' do
        spec = Lola.spec do
          define :something do
            (:s + :d) > 5
          end
          trigger :something
        end
        expect(spec.trigger? :something).to be_truthy
      end
      it 'does not set triggers all the time' do
        spec = Lola.spec do
          define :something do
            (:s + :d) > 5
          end
        end
        expect(spec.trigger? :something).to be_falsey
      end
    end

=begin
    describe 'usage tests' do

      class Balance
        Lola.spec do
          define :difference do
            look_back(:balance, 1, 0) - :balance
          end
          define :big_deduction do
            look_back(:balance, 1, 0) / 100
          end
          define :on_hold do
            :difference > :big_deduction
          end
          trigger :on_hold
        end

        attr_accessor :balance

        def send(to, amount)
          raise 'on hold!' if amount > (balance / 100)
          self.balance -= amount
          self.save # error happens here
          to.receive(balance)
        end
      end
      it 'does a big transaction that should be on hold' do
        balance = Balance.new
        balance.balance = 1000
        balance.save
        balance.send(Balance.new, 100)
      end
    end
=end
  end
end
